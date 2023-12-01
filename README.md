# VMwareLabBuild
A mix of Terraform and Ansible scripts to automate building nested VMware ESXi hosts and other stuff for a VMware lab. The project was to support my learning vSphere primarily, but also to learn more about Terraform and Ansible which I knew little about.

Started as a single Terraform hard-coded script, added Ansible to do the bits the Terraform provider wouldn't, have gradually been modularizing and removing the hard-coding, including pulling all the secrets out into Hashicorp Vault, allowing me to put this on Github (lets hope the tfstate file never accidentally ends up in this repo!).  

There is still plenty of hard-coding to remove, which will largely entail changing the code to pass variables from Terraform to the Ansible "local-execs" scripts.

You may notice that I build against ESXi hosts to start, and then use vCenter.  This reflects the evolutionary journey I have been on (and the fact to start I had only a single small PC to play with).  I could refactor to use vCenter only, but I think leaving the ESXi bits in is educational (and demonstrates what having multiple aliased providers looks like too).

I should add that for the NSX-T bits, I found usable documentation to be very hard to find.  However there is an incredibly good VMware Lab building repo by Rutger Blom (https://github.com/rutgerblom/SDDC.Lab) which I used extensivley as a reference. It is also a great demonstration of Ansible usage too (thanks Rutger!).
