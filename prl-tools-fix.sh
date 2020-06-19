#!/bin/sh

# 20171202 MK Parallels Tools Fix for Debian 9 (stretch) with kernel 4.9.0

# This script fixes compiler errors in parallels-tools from prl-tools-lin.iso so the
# installer works on Debian 9 guests. Make sure Paralles Tools is mounted on the guest VM
# and run script in the VM. If the tools are not mounted the script will try to mount
# the iso itself from current dir. After it's done the installer should work without errors.

# If you dont have Parallels Tools package you can get it on a hardware node
# from "/usr/share/parallels-server/tools". Or you can download latest version from
# http://updates.virtuozzo.com/cloudserver/6.0/Updates/Packages
# You need to get "parallels-server" (verify rpm checksum with repodata).
# The iso can be extracted like this:
# rpm2cpio parallels-server-6*.rpm | cpio -iv --to-stdout "*prl-tools-lin.iso" > prl-tools-lin.iso

# You can also just manually apply the included patch instead

# - Needs prl-tools-deb9.patch
# - Tested with PCS version 6.12.26053.1232091
# - Compared and verified changes with these other patches:
#   https://gist.github.com/rkitover/3c524cfe7c81a4a0bee286acd15f3714/revisions
#   https://aur.archlinux.org/cgit/aur.git/tree/0001-fix-for-4.9.y.patch?h=parallels-tools
# - prl_tg patch was changed to match the more correct patch by rikover

# For more info see Virtuozzo Forums/Support/KB

iso="prl-tools-lin.iso"
defmnt="/media/cdrom"
mod="prl_mod"
tools="parallels-tools"
#set -x
for i in $defmnt $( mount | grep ^/dev/sr | awk '{ print $3 }' ); do
  if test -f "$i/kmods/${mod}.tar.gz"; then mount="$i"; fi
done
if test ! -f "$mount/kmods/${mod}.tar.gz"; then
  if test -f "$iso"; then
    printf "Parallels Tools not mounted, trying to mount %s... " "$iso"
    if test ! -d "$defmnt"; then mkdir "$defmnt"; fi
    mount "$iso" "$defmnt" && mount="$defmnt"
    if test ! -f "$mount/kmods/${mod}.tar.gz"; then
      printf "Failed, exiting.\n"; exit 1
    fi
  else
    printf "Could not find Parallels Tools, exiting.\n"; exit 1
  fi
fi && mkdir "$tools"
for i in install installer kmods tools version; do cp -r "$mount/$i" "$tools"; done && \
if test ! -d "$tools/kmods/$mod"; then mkdir "$tools/kmods/$mod"; fi && \
tar -xf "$tools/kmods/${mod}.tar.gz" -C "$tools/kmods/$mod" && \
patch -p0 -i prl_fs.patch && patch -p0 -i prl_tg.patch && \
mv "$tools/kmods/${mod}.tar.gz" "${mod}.tar.gz.bak" && \
tar -C "$tools/kmods/$mod" --remove-files -zcf "$tools/kmods/${mod}.tar.gz" prl_fs/ prl_eth/ prl_tg/ dkms.conf Makefile.kmods && \
printf "\nDone. You can now run the installer as usual. To optionally create an updated iso:\n \
     \$ genisoimage -o prl-tools-lin.iso -R -J -l -v -V \"Parallels Tools\" parallels-tools\n\n" || \
printf "Something went wrong, try applying the patches manually.\n"
rmdir "$tools/kmods/$mod" >/dev/null 2>&1
