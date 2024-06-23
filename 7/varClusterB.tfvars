datacenterNameB  = "myDC"
clusterNameB     = "myClusterB"

esxiHostB        = "esxi7-04.vmware.soksy.org"
esxiHostIPB      = "192.168.4.34"
vcenterHostB     = "vcenter8.home.soksy.org"
sncNameB         = "ESXi7-04-SNC"

datastoreNameB   = "datastore-nvme-04-00"

vssSwitchB       = "vSwitchToR-A"
vssPortgroupB    = "PG-Nested-ToR-A"
vdsNameB         = "dvSwitchB"

mgmtPortgroupB   = "PG-Management-3"
mgmtVlanB        = 3

nested_hostsB    = {
    "esxi7-10" = { name = "esxi7-10", fqdn = "esxi7-10.vmware.soksy.org", mac = "00:50:56:86:35:fd", build-ip = "192.168.3.55", operating-ip = "192.168.3.35", storage-vmk-ip = "192.168.10.35", cores = 24, cps = 24, mem = 48000 },
    "esxi7-11" = { name = "esxi7-11", fqdn = "esxi7-11.vmware.soksy.org", mac = "00:50:56:86:36:fd", build-ip = "192.168.3.56", operating-ip = "192.168.3.36", storage-vmk-ip = "192.168.10.36", cores = 24, cps = 24, mem = 48000 },
    "esxi7-12" = { name = "esxi7-12", fqdn = "esxi7-12.vmware.soksy.org", mac = "00:50:56:86:37:fd", build-ip = "192.168.3.57", operating-ip = "192.168.3.37", storage-vmk-ip = "192.168.10.37", cores = 24, cps = 24, mem = 48000 },
}
