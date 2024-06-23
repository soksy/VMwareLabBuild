variable "dcName" {}
variable "clName" {}
variable "hosts" {}
variable "esxiUsername" {}
variable "esxiPassword" {}
variable "vCenterHost" {}
variable "vdsName" {}
variable "mgmtVlan" {}
variable "nestedESXiJSONEncoded" {}
variable "sncName" {}
variable "esxiHostIP" {}
variable "mgmtPortgroup" {}

data "vsphere_datacenter" "datacenter" {
  name = var.dcName
}

resource "vsphere_compute_cluster" "compute_cluster" {
  name            = var.clName
  datacenter_id   = data.vsphere_datacenter.datacenter.id
  host_managed    = true
  drs_enabled     = true
  drs_automation_level = "fullyAutomated"

  ha_enabled = true
}

data "vsphere_host_thumbprint" "thumbprint" {
  for_each   = var.hosts
  address = each.value.fqdn
  insecure = true
}

resource "vsphere_host" "host" {
  for_each   = var.hosts
  hostname   = each.value.fqdn
  thumbprint = data.vsphere_host_thumbprint.thumbprint[each.key].id
  username   = var.esxiUsername
  password   = var.esxiPassword
  cluster    = vsphere_compute_cluster.compute_cluster.id
}

resource "time_sleep" "pause_for_cluster" {
  depends_on = [ vsphere_host.host ]
  create_duration = "60s"
}

resource "null_resource" "config_vds" {
  depends_on = [ time_sleep.pause_for_cluster ]
  provisioner "local-exec" {
    command = "ansible-playbook -vvv --extra-vars \"mgmtPortgroup=${var.mgmtPortgroup} vcenterHost=${var.vCenterHost} datacenterName=${var.dcName} vdsName=${var.vdsName} vlanID=${var.mgmtVlan}\" configVDS.8.yaml"
    environment = {
      nestedESXiJSONEncoded = var.nestedESXiJSONEncoded
    }
  } 
}

resource "null_resource" "config_vmk0_services" {
  depends_on = [ null_resource.config_vds ]
  provisioner "local-exec" {
    command = "ansible-playbook --extra-vars \"mgmtPortgroup=${var.mgmtPortgroup} vcenterHost=${var.vCenterHost} vdsName=${var.vdsName}\" configVMK0.8.yaml"
    environment = {
      nestedESXiJSONEncoded = var.nestedESXiJSONEncoded
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
      vcenterHost = var.vCenterHost
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