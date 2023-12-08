datacenterName = "myDC"
clusterName = "myClusterA"

esxiHost = "esxi7.vmware.soksy.org"
esxiHostIP = "192.168.1.200"
vcenterHost = "vcenter.home.soksy.org"
sncName = "esxi-real-1"

datastoreName = "datastore-nvme-07-00"

vdsName = "dvSwitchA"

mgmtPortgroup = "PG-Management-2"
mgmtVlan = 2

nested_hosts = {
    "esxi8-00" = { name = "esxi8-00", fqdn = "esxi8-00.vmware.soksy.org", mac = "00:50:56:86:30:fd", build-ip = "192.168.2.50", operating-ip = "192.168.2.30", storage-vmk-ip = "192.168.10.30", cores = 24, cps = 24, mem = 48000},
    "esxi8-01" = { name = "esxi8-01", fqdn = "esxi8-01.vmware.soksy.org", mac = "00:50:56:86:31:fd", build-ip = "192.168.2.51", operating-ip = "192.168.2.31", storage-vmk-ip = "192.168.10.31", cores = 24, cps = 24, mem = 48000},
    "esxi8-02" = { name = "esxi8-02", fqdn = "esxi8-02.vmware.soksy.org", mac = "00:50:56:86:32:fd", build-ip = "192.168.2.52", operating-ip = "192.168.2.32", storage-vmk-ip = "192.168.10.32", cores = 24, cps = 24, mem = 48000},
  }