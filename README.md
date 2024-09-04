## Prerequisites

Before starting, ensure that you have the necessary dependencies:

1. **DKMS** (Dynamic Kernel Module Support), which will handle automatic module rebuilds after kernel updates. You can install it by running:

   ```bash
   sudo apt-get install dkms
   ```

## Step-by-Step Installation Guide

### 1. Clone the AIC8800-DKMS Repository

First, clone the **AIC8800-DKMS** repository from GitHub to your local machine:

```bash
git clone https://github.com/geniuskidkanyi/aic8800
```

Navigate to the downloaded directory:

```bash
cd aic8800
```

### 2. Copy Source Files to `/usr/src/`

Next, copy the source code to the `/usr/src/` directory so that DKMS can track and manage the module:

```bash
sudo cp -r src /usr/src/aic8800-1.0.5
```

The `1.0.5` reflects the version number of the module. Ensure this is correct.

### 3. Copy Firmware Blobs

Firmware blobs are essential for the module to work properly. Copy these to the `/usr/lib/firmware/` directory:

```bash
sudo cp -r blobs/* /usr/lib/firmware/
```

### 4. Install the AIC8800 Wi-Fi Module with DKMS

Now that the files are in place, use DKMS to install the module:

```bash
dkms install aic8800/1.0.5
```

This command will add the AIC8800 module to DKMS, allowing it to automatically manage it during kernel upgrades.

### 5. Load the AIC8800 Driver

Once installed, load the driver with the following command:

```bash
sudo modprobe aic8800_fdrv
```

This command activates the module and ensures that your system recognizes the wireless chipset supported by AIC8800.

### 6. Verify the Installation and Driver Activation

To confirm the installation, check the status of the DKMS module by running:

```bash
dkms status
```

This will display the AIC8800 module version and confirm whether it is associated with the current kernel.

You can also confirm that the driver is loaded with:

```bash
lsmod | grep aic8800_fdrv
```

If successful, this command will display information about the loaded module.

### 7. Reboot the System

For all changes to take effect, reboot your system:

```bash
sudo reboot
```

This will ensure that the AIC8800 Wi-Fi driver is fully integrated and working as expected after the restart.
