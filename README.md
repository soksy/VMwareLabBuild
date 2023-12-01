# VMwareLabBuild
A mix of Terraform and Ansible scripts to automate building nested VMware ESXi hosts and other stuff for a VMware lab.

Started as a single Terraform hard-coded script, added Ansible to do the bits the Terraform provider wouldnt, have gradually been modularizing and removing the hard-coding, including pulling all the secrets out into Hashicorp Vault, allowing me to put this on Github.
