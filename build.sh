#!/bin/bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"

VERSION=1.0.5

sudo apt-get install -y git dkms usb-modeswitch

#Assuming we just got this script without the aic8800 repo..
#git clone https://github.com/geniuskidkanyi/aic8800
#cd aic8800

#Also include aic8800D80 (skip if we already fetched it)
if [ ! -d blobs/aic8800D80 ]; then
  rm -rf aic8800D80
  git clone https://github.com/jeremyb31/aic8800D80.git
  mv aic8800D80/aic8800D80 blobs/
  rm -rf aic8800D80
fi

#Drop any previous build before replacing the sources
sudo dkms remove aic8800/$VERSION --all || true

#Wipe the destination first, otherwise cp nests src/ inside it
sudo rm -rf /usr/src/aic8800-$VERSION
sudo cp -r src /usr/src/aic8800-$VERSION
sudo cp -r blobs/* /usr/lib/firmware/

#Build for every installed kernel that has headers, not just the running one
for KVER in $(ls /lib/modules); do
  if [ -d "/lib/modules/$KVER/build" ]; then
    echo "=== building for $KVER ==="
    sudo dkms install aic8800/$VERSION -k "$KVER" || true
  fi
done

sudo dkms status | grep aic8800

#The dongle enumerates as a mass-storage "driver CD" (a69c:5721) and needs
#usb_modeswitch to become a WiFi device. Once switched, aic_load_fw and
#aic8800_fdrv bind on their own via modalias - no extra rules needed.
sudo tee /etc/udev/rules.d/50-custom.rules >/dev/null <<'RULES'
ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="a69c", ATTR{idProduct}=="5721", RUN+="/usr/sbin/usb_modeswitch -K -v a69c -p 5721"
RULES
sudo udevadm control --reload-rules

echo
echo "Done. Unplug and replug the dongle, then check with:  ip -br link show"

exit 0
