#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y upgrade

# remove debconf warnings (i.e. dialog and falling back to frontend: Readline)
apt-get install -y dialog apt-utils

# see https://stackoverflow.com/questions/4749330/how-to-test-if-string-exists-in-file-with-bash-shell
NOMODESET='GRUB_CMDLINE_LINUX_DEFAULT="$GRUB_CMDLINE_LINUX_DEFAULT nouveau.modeset=0"'
if grep -Fxq ${NOMODESET} /etc/default/grub
then
    echo "****GRUB_CMDLINE_LINUX_DEFAULT already fixed"
else
    echo "****GRUB_CMDLINE_LINUX_DEFAULT fixing"
    ${NOMODESET} >> /etc/default/grub
fi

# linux-image-extra is installed
apt-get install -y linux-image-extra-xenial
# packages related for APT with https are installed
apt-get install -y apt-transport-https ca-certificates
# software-properties-common is installed for prerequisite for apt_repository ansible module
apt-get install -y software-properties-common