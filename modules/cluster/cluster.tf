variable "dcName" {}
variable "clName" {}
variable "hosts" {}
variable "esxiUsername" {}
variable "esxiPassword" {}

data "vsphere_datacenter" "datacenter" {
  name = var.dcName
}

resource "vsphere_compute_cluster" "compute_cluster" {
  name                 = var.clName
  datacenter_id        = data.vsphere_datacenter.datacenter.id
  host_managed         = true
  drs_enabled          = true
  drs_automation_level = "fullyAutomated"

  ha_enabled = true
}

data "vsphere_host_thumbprint" "thumbprint" {
  for_each = var.hosts
  address  = each.value.fqdn
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

