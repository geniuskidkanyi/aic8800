## Dependencies 
 - dkms

## Installing
```shell
git clone https://github.com/fqrious/aic8800-dkms
cd aic8800-dkms
sudo cp -r src /usr/src/aic8800-1.0.5
sudo cp -r blobs/* /usr/lib/firmware/
dkms install aic8800/1.0.5
```
