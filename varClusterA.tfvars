datacenterName = "myDC"
clusterName = "myClusterA"

esxiHost = "esxi7.vmware.soksy.org"
vcenterHost = "vcenter.home.soksy.org"
sncName = "esxi-real-1"

datastoreName = "datastore-nvme-07-00"

vdsName = "dvSwitchA"

mgmtVlan = 2

nested_hosts = {
    "esxi8-00" = { name = "esxi8-00", fqdn = "esxi8-00.vmware.soksy.org", mac = "00:50:56:86:30:fd", build-ip = "192.168.2.50", cores = 24, cps = 24, mem = 48000},
    "esxi8-01" = { name = "esxi8-01", fqdn = "esxi8-01.vmware.soksy.org", mac = "00:50:56:86:31:fd", build-ip = "192.168.2.51", cores = 24, cps = 24, mem = 48000},
    "esxi8-02" = { name = "esxi8-02", fqdn = "esxi8-02.vmware.soksy.org", mac = "00:50:56:86:32:fd", build-ip = "192.168.2.52", cores = 24, cps = 24, mem = 48000},
  }