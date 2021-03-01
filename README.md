_Not needed on Debian 10 (buster), since prl-tools works fine_

# Parallels Tools Fix for Debian 9 (stretch) 
### Kernel 4.9.0

This script fixes compile errors in parallels-tools (from prl-tools-lin.iso) so the installer works on Debian 9 guests.

Make sure Paralles Tools is mounted on the guest VM and run script in the VM. If the tools are not mounted the script will try to mount the iso itself from current dir. After it's done the installer should work without errors.  

If you dont have Parallels Tools package you can get it on a hardware node  
from "/usr/share/parallels-server/tools". Or you can download latest version from  
http://updates.virtuozzo.com/cloudserver/6.0/Updates/Packages  
You need to get "parallels-server" (verify rpm checksum with repodata).  
The iso can be extracted like this:  
`$ rpm2cpio parallels-server-6*.rpm | cpio -iv --to-stdout "*prl-tools-lin.iso" > prl-tools-lin.iso` 

You can also just manually apply the included patch instead  

- Needs prl-tools-deb9.patch  
- Tested with PCS version 6.12.26053.1232091  
- Compared and verified changes with these other patches:  
  https://gist.github.com/rkitover/3c524cfe7c81a4a0bee286acd15f3714/revisions  
  https://aur.archlinux.org/cgit/aur.git/tree/0001-fix-for-4.9.y.patch?h=parallels-tools  
- prl_tg patch was changed to match the more correct patch by rikover  

To optionally create an updated iso (mkiso can also be used):  
`$ genisoimage -o prl-tools-lin.iso -R -J -l -v -V "Parallels Tools" parallels-tools`  

For more info see Virtuozzo Forums/Support/KB  
