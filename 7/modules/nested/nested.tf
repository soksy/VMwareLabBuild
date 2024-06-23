variable "hostmap" {}
variable "datastorename" {}
variable "mgmtVlan" {}
variable "esxiHost" {}
variable "vssSwitch" {}
variable "vssPortgroup" {}
variable "nestedESXiJSONEncoded" {
  
}

# This is using the default esxi DC name (whatever that is!!)
data "vsphere_datacenter" "datacenter" {
}

data "vsphere_datastore" "datastore" {
  name          = var.datastorename 
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "data_network_ToR-A" {
  name          = "PG-Nested-ToR-A"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "data_network_ToR-B" {
  name          = "PG-Nested-ToR-B"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "storage_network" {
  name          = "PG-Storage"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_resource_pool" "pool" {
}

resource "null_resource" "PG-Nested-VLANX" {
  provisioner "local-exec" {
    command = "ansible-playbook --extra-vars \"vlanID=${var.mgmtVlan} esxiHost=${var.esxiHost} switchName=${var.vssSwitch} portgroupName=${var.vssPortgroup}\" setPGNestedVLANX.yaml"
  } 
}

resource "vsphere_virtual_machine" "esxi-nested-host" {
  depends_on = [ null_resource.PG-Nested-VLANX ]

  for_each         = var.hostmap

  name             = each.value.name
  datastore_id     = data.vsphere_datastore.datastore.id
  resource_pool_id = data.vsphere_resource_pool.pool.id
  num_cpus         = each.value.cores
  num_cores_per_socket = each.value.cps
  memory           = each.value.mem
  guest_id         = "vmkernel7Guest"
  firmware         = "efi"
  nested_hv_enabled = true
  wait_for_guest_ip_timeout  = 10000
  wait_for_guest_net_timeout = -1
  ignored_guest_ips = [ each.value.build-ip ]
  network_interface {
    network_id = data.vsphere_network.data_network_ToR-A.id
    adapter_type   = "vmxnet3"
    use_static_mac = true
    mac_address     = each.value.mac
  }
  network_interface {
    network_id = data.vsphere_network.data_network_ToR-B.id
    adapter_type   = "vmxnet3"
  }
  network_interface {
    network_id = data.vsphere_network.storage_network.id
    adapter_type   = "vmxnet3"
  }
  disk {
    label            = "disk0"
    size             = 32
    eagerly_scrub    = false
    thin_provisioned = true
  }
  #disk {
  #  label            = "disk1"
  #  size             = 16
  #  eagerly_scrub    = false
  #  thin_provisioned = true
  #  unit_number      = 1
  #}
  #disk {
  #  label            = "disk2"
  #  size             = 160
  #  eagerly_scrub    = false
  #  thin_provisioned = true
  #  unit_number      = 2
  #}
}

resource "time_sleep" "pause_for_cmi" {
  depends_on = [ vsphere_virtual_machine.esxi-nested-host ]
  create_duration = "15s"
}

resource "null_resource" "PG-Nested-Trunk" {
  depends_on = [ time_sleep.pause_for_cmi ]
  provisioner "local-exec" {
    command = "ansible-playbook --extra-vars \"esxiHost=${var.esxiHost} switchName=${var.vssSwitch} portgroupName=${var.vssPortgroup}\" setPGNestedTrunk.yaml"
  }
}

resource "null_resource" "config_storage" {
  depends_on = [ null_resource.PG-Nested-Trunk ]
  provisioner "local-exec" {
    command = "ansible-playbook configNestedESX.7.yaml"
    environment = {
      nestedESXiJSONEncoded = var.nestedESXiJSONEncoded
    }
  } 
}



