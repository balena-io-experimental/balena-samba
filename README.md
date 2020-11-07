# balena-samba

## Highlights
- Plug in your USB drives to share them over the network using Samba.
- USB drives are automatically mounted and shared as soon as they are plugged in.
- The Samba shares are protected with a configurable username & password.
- Supports ext3, ext4, EXFAT, FAT32, and NTFS file systems.

## Setup and Configuration
Running this project is as simple as deploying it to a balenaCloud application. You can do it in just one click by using the button below:

[![deploy button](https://balena.io/deploy.png)](https://dashboard.balena-cloud.com/deploy?repoUrl=https://github.com/balena-io-playground/balena-samba&defaultDeviceType=raspberrypi4-64)

Change the username and password of the Samba shares by setting the following environment variables for your application or device:
- `SAMBA_USERNAME` - the default is `balena`
- `SAMBA_PASSWORD` - the default is `balena`
 
You can read more about environment variables [here](https://www.balena.io/docs/learn/manage/serv-vars/#fleet-environment-and-service-variables).

## Usage
Plug in your USB drive to automatically share it over the network using Samba.  The USB drive will automatically have a private share with a name prefixed with "Shared-".  For example, a device with a device path of `/dev/sda1` will be shared as `Shared-sda1`.

Run the command `drive remove <disk>` to safely remove the USB drive from the Samba shares and unmount it from the system to be unplugged. The `<disk>` is the device name.  Unplugging a USB drive automatically removes the share name and cleans up the mount path.

## License
Copyright 2020 Balena Ltd

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at:

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.