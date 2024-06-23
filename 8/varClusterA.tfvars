datacenterNameA  = "myDC"
clusterNameA     = "myClusterA"

esxiHostA        = "esxi7.vmware.soksy.org"
esxiHostIPA      = "192.168.4.200"
vcenterHostA     = "vcenter.home.soksy.org"
sncNameA         = "ESXi7-07-SNC"

datastoreNameA   = "datastore-nvme-07-00"

vssSwitchA       = "vSwitchToR-A"
vssPortgroupA    = "PG-Nested-ToR-A"
vdsNameA         = "dvSwitchA"

mgmtPortgroupA   = "PG-Management-2"
mgmtVlanA        = 2

nested_hostsA    = {
    "esxi8-00" = { name = "esxi8-00", fqdn = "esxi8-00.vmware.soksy.org", mac = "00:50:56:86:30:fd", build-ip = "192.168.2.50", operating-ip = "192.168.2.30", storage-vmk-ip = "192.168.10.30", cores = 24, cps = 24, mem = 48000},
    "esxi8-01" = { name = "esxi8-01", fqdn = "esxi8-01.vmware.soksy.org", mac = "00:50:56:86:31:fd", build-ip = "192.168.2.51", operating-ip = "192.168.2.31", storage-vmk-ip = "192.168.10.31", cores = 24, cps = 24, mem = 48000},
    "esxi8-02" = { name = "esxi8-02", fqdn = "esxi8-02.vmware.soksy.org", mac = "00:50:56:86:32:fd", build-ip = "192.168.2.52", operating-ip = "192.168.2.32", storage-vmk-ip = "192.168.10.32", cores = 24, cps = 24, mem = 48000},
  }
