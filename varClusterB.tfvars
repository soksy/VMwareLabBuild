datacenterName = "myDCA"
clusterName    = "myClusterB"

esxiHost    = "esxi7-04.vmware.soksy.org"
esxiHostIP  = "192.168.1.34"
vcenterHost = "vcenter.home.soksy.org"
sncName     = "esxi-real-2"

datastoreName = "datastore-nvme-04-00"

vdsName = "dvSwitchB"

mgmtPortgroup = "PG-Management-3"
mgmtVlan      = 3

nested_hosts = {
  "esxi8-10" = { name = "esxi8-10", fqdn = "esxi8-10.vmware.soksy.org", mac = "00:50:56:86:35:fd", build-ip = "192.168.3.55", operating-ip = "192.168.3.35", storage-vmk-ip = "192.168.10.35", cores = 24, cps = 24, mem = 48000 },
  "esxi8-11" = { name = "esxi8-11", fqdn = "esxi8-11.vmware.soksy.org", mac = "00:50:56:86:36:fd", build-ip = "192.168.3.56", operating-ip = "192.168.3.36", storage-vmk-ip = "192.168.10.36", cores = 24, cps = 24, mem = 48000 },
  "esxi8-12" = { name = "esxi8-12", fqdn = "esxi8-12.vmware.soksy.org", mac = "00:50:56:86:37:fd", build-ip = "192.168.3.57", operating-ip = "192.168.3.37", storage-vmk-ip = "192.168.10.37", cores = 24, cps = 24, mem = 48000 },
}
