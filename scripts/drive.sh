#!/bin/bash

function attach {
  DISK=$1
  if mount_disk $DISK $SAMBA_ROOT/$DISK
    then
      create_config $DISK $SAMBA_ROOT/$DISK
  fi
}

function create_config {
  DISK=$1
  SHARE_PATH=$2
  SHARE_NAME=$(udevadm info -n /dev/${DISK} | grep ID_SERIAL= | cut -d'=' -f2 | cut -d":" -f1)
  echo "[${DISK}-${SHARE_NAME}]
  path = ${SHARE_PATH}
  valid users = @smbgroup
  guest ok = no
  writable = yes
  browsable = yes
  " >> ${CONFIG_DIR}/Shared-${DISK}.conf 
}

function mount_disk {
  DISK=$1
  SHARE_PATH=$2
  echo "Attempting to mount ${DISK} to ${SHARE_PATH}."
  mkdir -p $SHARE_PATH
  chown -R root:smbgroup $SHARE_PATH
  chmod -R 0777 $SHARE_PATH
  if mount -o dmask=000,fmask=111,user /dev/$DISK $SHARE_PATH
  then
    echo "Success."
    return 0
  else
    echo "Failed."
    return 1
  fi
}

function print_usage {
  echo "
  $0 <command> [device]

  Commands:
    attach - Mounts a device then creates a Samba share
    remove - Removes the Samba share then unmounts the device

  Parameters:
    device - The name of the device to be mounted (i.e. sda1, sda2, sdb1, ...)
             If the device parameter is not provided, the script looks into the
             DEVNAME environment variable for the full path of the device.
             This environment variable is used for automatic attachment and
             removal of devices using udev rules.
  "
}

function reload_samba {
  cat ${CONFIG_DIR}/smb-global.conf > /etc/samba/smb.conf
  for CONFIG_FILE in `ls ${CONFIG_DIR}/Shared-*`
  do
    cat $CONFIG_FILE >> /etc/samba/smb.conf
  done
  killall -HUP smbd
}

function remove {
  DISK=$1
  rm -f ${CONFIG_DIR}/Shared-${DISK}.conf 
  unmount_disk $DISK $SAMBA_ROOT/$DISK
}

function unmount_disk {
  DISK=$1
  SHARE_PATH=$2
  echo "Attempting to unmount ${DISK} from ${SHARE_PATH}."
  if umount -f /dev/$DISK
  then
    rmdir $SHARE_PATH
    echo "Success."
    return 0
  else
    echo "Failed."
    return 1
  fi
}

function main {
  if [ -z $2 ]
  then
    DEVICE=$(echo $DEVNAME | cut -d '/' -f 3)
  else
    DEVICE=$2
  fi
  case $1 in
  'attach')
    attach $DEVICE
    ;;
  'remove')
    remove $DEVICE
    ;;
  *)
    print_usage
    ;;
  esac
  reload_samba
}

main $@