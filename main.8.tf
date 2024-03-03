variable datacenterNameA {}
variable clusterNameA {}
variable esxiHostA {}
variable esxiHostIPA {}
variable vcenterHostA {}
variable sncNameA {}
variable datastoreNameA {} 
variable vssSwitchA {}
variable vssPortgroupA {}
variable vdsNameA {}
variable mgmtVlanA {}
variable mgmtPortgroupA {}
variable nested_hostsA {}

variable datacenterNameB {}
variable clusterNameB {}
variable esxiHostB {}
variable esxiHostIPB {}
variable vcenterHostB {}
variable sncNameB {}
variable datastoreNameB {} 
variable vssSwitchB {}
variable vssPortgroupB {}
variable vdsNameB {}
variable mgmtVlanB {}
variable mgmtPortgroupB {}
variable nested_hostsB {}

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
  nestedESXiJSONEncodedA  = jsonencode(var.nested_hostsA)
  nestedESXiJSONEncodedB  = jsonencode(var.nested_hostsB)
}

output "TheESXiList" {
  value = local.nestedESXiJSONEncodedA
}

provider "vsphere" {
  alias                = "vcenterA"
  user                 =  local.vcenter_username
  password             =  local.vcenter_password
  allow_unverified_ssl = true
  vsphere_server       = var.vcenterHostA
}

provider "vsphere" {
  alias                = "esxiA"
  user                 =  local.esxiUsername
  password             =  local.esxiPassword
  allow_unverified_ssl = true
  vsphere_server       = var.esxiHostA
}

provider "vsphere" {
  alias                = "esxiB"
  user                 =  local.esxiUsername
  password             =  local.esxiPassword
  allow_unverified_ssl = true
  vsphere_server       = var.esxiHostB
}

module "nestedA" {
  source        = "./modules/nested"
  providers     = {
    vsphere = vsphere.esxiA
  }
  hostmap       = var.nested_hostsA
  datastorename = var.datastoreNameA
  mgmtVlan      = var.mgmtVlanA
  esxiHost      = var.esxiHostA
  vssSwitch     = var.vssSwitchA
  vssPortgroup  = var.vssPortgroupA
  nestedESXiJSONEncoded = local.nestedESXiJSONEncodedA
}

module "nestedB" {
  source        = "./modules/nested"
  providers     = {
    vsphere = vsphere.esxiB
  }
  hostmap       = var.nested_hostsB
  datastorename = var.datastoreNameB
  mgmtVlan      = var.mgmtVlanB
  esxiHost      = var.esxiHostB
  vssSwitch     = var.vssSwitchB
  vssPortgroup  = var.vssPortgroupB
  nestedESXiJSONEncoded = local.nestedESXiJSONEncodedB
}

resource "vsphere_datacenter" "datacenter" {
  depends_on = [ module.nestedA, module.nestedB ]
  provider = vsphere.vcenterA
  name = var.datacenterNameA
}

module "clusterA" {
  depends_on = [ vsphere_datacenter.datacenter ]
  source = "./modules/cluster"
  providers = {
    vsphere = vsphere.vcenterA
  }
  dcName        = var.datacenterNameA
  clName        = var.clusterNameA
  hosts         = var.nested_hostsA
  esxiUsername  = local.esxiUsername
  esxiPassword  = local.esxiPassword
  vCenterHost   = var.vcenterHostA
  vdsName       = var.vdsNameA
  mgmtVlan      = var.mgmtVlanA
  nestedESXiJSONEncoded = local.nestedESXiJSONEncodedA
  sncName       = var.sncNameA
  esxiHostIP    = var.esxiHostIPA
  mgmtPortgroup = var.mgmtPortgroupA
}

module "clusterB" {
  depends_on = [ vsphere_datacenter.datacenter ]
  source = "./modules/cluster"
  providers = {
    vsphere = vsphere.vcenterA
  }
  dcName        = var.datacenterNameB
  clName        = var.clusterNameB
  hosts         = var.nested_hostsB
  esxiUsername  = local.esxiUsername
  esxiPassword  = local.esxiPassword
  vCenterHost   = var.vcenterHostB
  vdsName       = var.vdsNameB
  mgmtVlan      = var.mgmtVlanB
  nestedESXiJSONEncoded = local.nestedESXiJSONEncodedB
  sncName       = var.sncNameB
  esxiHostIP    = var.esxiHostIPB
  mgmtPortgroup = var.mgmtPortgroupB
}
