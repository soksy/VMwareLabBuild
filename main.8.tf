variable datacenterName {}
variable clusterName {}
variable esxiHost {}
variable esxiHostIP {}
variable vcenterHost {}
variable datastoreName {} 
variable vdsName {}
variable mgmtPortgroup {}
variable mgmtVlan {}
variable nested_hosts {}
variable sncName {}

variable "VAULT_ADDR" {
  description = "URL of Hashicorp Vault instance."
}

variable "VAULT_TOKEN" {
  description = "Token for Hashicorp access."
  sensitive = true
}

provider "vault" {
  address = var.VAULT_ADDR
  token   = var.VAULT_TOKEN
}

data "vault_generic_secret" "vmware" {
  path = "secret/vmware"
}

locals {
  vcenter_username = data.vault_generic_secret.vmware.data["vcenter_username"]
  vcenter_password = data.vault_generic_secret.vmware.data["vcenter_password"]
  esxiUsername     = data.vault_generic_secret.vmware.data["esxi_username"]
  esxiPassword     = data.vault_generic_secret.vmware.data["esxi_password"]
  nestedESXiJSONEncoded  = jsonencode(var.nested_hosts)
}

provider "vsphere" {
  alias                = "vcenter"
  user                 =  local.vcenter_username
  password             =  local.vcenter_password
  allow_unverified_ssl = true
  vsphere_server       = var.vcenterHost
}

provider "vsphere" {
  alias                = "esxi"
  user                 =  local.esxiUsername
  password             =  local.esxiPassword
  allow_unverified_ssl = true
  vsphere_server       = var.esxiHost
}


resource "null_resource" "PG-Nested-VLANX" {
  depends_on = [ null_resource.disconnect_physical_esx ]
  provisioner "local-exec" {
    command = "ansible-playbook --extra-vars \"vlanID=${var.mgmtVlan} esxiHost=${var.esxiHost}\" setPGNestedVLANX.yaml"
  } 
}

module "nested" {
  depends_on = [ null_resource.PG-Nested-VLANX ]
  source    = "./modules/nested"
  providers = {
    vsphere = vsphere.esxi
  }
  hostmap   = var.nested_hosts
  datastorename = var.datastoreName
}

resource "time_sleep" "pause_for_cmi" {
  depends_on = [ module.nested ]
  create_duration = "15s"
}

resource "null_resource" "PG-Nested-Trunk" {
  depends_on = [ time_sleep.pause_for_cmi ]
  provisioner "local-exec" {
    command = "ansible-playbook --extra-vars esxiHost=${var.esxiHost} setPGNestedTrunk.yaml"
  }
}

resource "null_resource" "config_storage" {
  depends_on = [ null_resource.PG-Nested-Trunk ]
  provisioner "local-exec" {
    command = "ansible-playbook configNestedESX.8.yaml"
    environment = {
      nestedESXiJSONEncoded = local.nestedESXiJSONEncoded
    }
  } 
}


module "cluster" {
  depends_on = [ null_resource.config_storage ]
  source = "./modules/cluster"
  providers = {
    vsphere = vsphere.vcenter
  }
  dcName = var.datacenterName
  clName = var.clusterName
  hosts  = var.nested_hosts
  esxiUsername = local.esxiUsername
  esxiPassword = local.esxiPassword
}

resource "time_sleep" "pause_for_cluster" {
  depends_on = [ module.cluster ]
  create_duration = "60s"
}

resource "null_resource" "config_vds" {
  depends_on = [ time_sleep.pause_for_cluster ]
  provisioner "local-exec" {
    command = "ansible-playbook -vvv --extra-vars \"vcenterHost=${var.vcenterHost} datacenterName=${var.datacenterName} vdsName=${var.vdsName} mgmtPortgroup=${var.mgmtPortgroup} vlanID=${var.mgmtVlan}\" configVDS.8.yaml"
    environment = {
      nestedESXiJSONEncoded = local.nestedESXiJSONEncoded
    }
  } 
}

resource "null_resource" "config_vmk0_services" {
  depends_on = [ null_resource.config_vds ]
  provisioner "local-exec" {
    command = "ansible-playbook --extra-vars \"vcenterHost=${var.vcenterHost} mgmtPortgroup=${var.mgmtPortgroup} vdsName=${var.vdsName}\" configVMK0.8.yaml"
    environment = {
      nestedESXiJSONEncoded = local.nestedESXiJSONEncoded
    }
  }

}

#resource "null_resource" "config_TPM_prep_vSAN" {
#  depends_on = [ null_resource.config_vmk0_services ]
#  provisioner "local-exec" {
#    command = "ansible-playbook TPMandVSANPrep.8.yaml"
#  }
#}

resource "null_resource" "disconnect_physical_esx" {
    triggers = {
      ensures-invoked-everytime = uuid()
      vcenterHost = var.vcenterHost
      sncName = var.sncName
      esxiHostIP = var.esxiHostIP
    }

  provisioner "local-exec" {
    when = destroy
    command = "ansible-playbook disconnectPhysESX.yaml"

    environment = {
      vcenterHost = self.triggers.vcenterHost
      esxiHostIP = self.triggers.esxiHostIP
      sncName = self.triggers.sncName
    }
  }
}


