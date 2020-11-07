#!/bin/bash

function setup_user {
  SMB_USER=${SAMBA_USERNAME:=balena}
  SMB_PASS=${SAMBA_PASSWORD:=balena}
  useradd --no-create-home $SMB_USER
  usermod -aG smbgroup $SMB_USER
  printf "${SMB_PASS}\n${SMB_PASS}\n" | smbpasswd -a -s $SMB_USER
  smbpasswd -e $SMB_USER
}

function main {
  cat config/smb-global.conf > /etc/samba/smb.conf
  for DISK in `lsblk -o KNAME | egrep sd[a-z][0-9]`
  do
    drive attach $DISK
  done
  setup_user
  smbd $@
}

main $@