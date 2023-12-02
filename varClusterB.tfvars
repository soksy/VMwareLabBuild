datacenterName = "myDC"
clusterName = "myClusterB"

esxiHost = "esxi7-04.vmware.soksy.org"
vcenterHost = "vcenter.home.soksy.org"
sncName = "esxi-real-2"

datastoreName = "datastore-nvme-04-00"

vdsName = "dvSwitchB"

mgmtVlan = 3

variable nested_hosts {
    "esxi8-10" = { name = "esxi8-10", fqdn = "esxi8-10.vmware.soksy.org", mac = "00:50:56:86:35:fd", build-ip = "192.168.3.55", cores = 24, cps = 24, mem = 48000},
    "esxi8-11" = { name = "esxi8-11", fqdn = "esxi8-11.vmware.soksy.org", mac = "00:50:56:86:36:fd", build-ip = "192.168.3.56", cores = 24, cps = 24, mem = 48000},
    "esxi8-12" = { name = "esxi8-12", fqdn = "esxi8-12.vmware.soksy.org", mac = "00:50:56:86:37:fd", build-ip = "192.168.3.57", cores = 24, cps = 24, mem = 48000},
  }