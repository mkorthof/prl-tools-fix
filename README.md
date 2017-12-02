# Parallels Tools Fix for Debian 9 (stretch) with kernel 4.9.0

This script fixes compiles errors in parallels-modtgz from prl-modtgz-lin.iso so the
installer works on Debian 9 guests. Make sure Paralles Tools is mounted on the guest VM 
and run script in the VM. If the tools are not mounted the script will try to mount
the iso itself from current dir. After it's done the installer should work without errors.

If you dont have Parallels Tools package you can get it on a hardware node
from "/usr/share/parallels-server/modtgz". Or you can download latest version from
http://updates.virtuozzo.com/cloudserver/6.0/Updates/Packages
You need to get "parallels-server-6*.rpm". The iso can be extracted with cpio :
rpm2cpio parallels-server-6*.rpm | cpio -iv --to-stdout "*prl-tools-lin.iso" > prl-tools-lin.iso

You can also just manually apply the included patch instead

- Needs prl-tools-deb9.patch
- Tested with PCS version 6.12.26053.1232091
- Compared and verfied changed with these other patches:
  https://gist.github.com/rkitover/3c524cfe7c81a4a0bee286acd15f3714/revisions
  https://aur.archlinux.org/cgit/aur.git/tree/0001-fix-for-4.9.y.patch?h=parallels-modtgz
- prl_tg patch was changed to match more correct rikover's patch
