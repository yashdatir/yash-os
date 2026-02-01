# 🐧 Yash OS

Yash OS is a minimal Linux distribution built using **Buildroot**,
focused on understanding the Linux boot process, kernel--root filesystem
integration, and system bring-up using **QEMU**.

This project keeps everything explicit and transparent to help learn how
a Linux system boots from scratch.

------------------------------------------------------------------------

## 📁 Repository Structure

```text
yash-os/
├── kernel/        # Linux kernel image (bzImage)
├── rootfs/        # Buildroot-generated root filesystem (rootfs.tar)
├── configs/       # Bootloader configuration (extlinux.conf)
├── scripts/       # Build and run scripts
├── build/         # Generated artifacts (auto-created, gitignored)
└── README.md

------------------------------------------------------------------------
```
## Requirements

Make sure the following are installed on your system:

-   qemu-system-x86_64
-   extlinux
-   bash
-   sudo access
-   KVM enabled (recommended for better performance)

------------------------------------------------------------------------

## Steps to Start Yash OS (QEMU)

### Step 1: Make the run script executable

chmod +x scripts/run-qemu.sh

------------------------------------------------------------------------

### Step 2: Run the QEMU boot script

./scripts/run-qemu.sh

This script will: - Create a bootable ext4 disk image inside the build/
directory - Install the EXTLINUX bootloader - Populate the root
filesystem - Launch QEMU

------------------------------------------------------------------------

### Step 3: Boot the OS from the EXTLINUX prompt

After QEMU starts, you may see an **EXTLINUX boot\> prompt**.

At the prompt, type the following command and press Enter:

`bzImage root=/dev/sda`

This command: - Specifies the kernel image (bzImage) - Sets the root
filesystem device to /dev/sda

The Linux kernel will then boot and start Yash OS.

------------------------------------------------------------------------

## System Details

-   Architecture: x86_64
-   Kernel: Linux (bzImage)
-   Root filesystem: Buildroot (BusyBox-based)
-   Filesystem: ext4
-   Bootloader: EXTLINUX
-   Emulator: QEMU

------------------------------------------------------------------------

## Project Purpose

This project is intended for: - Learning Linux internals - Understanding
early boot and kernel command lines - Practicing embedded and systems
engineering concepts

------------------------------------------------------------------------

## License

MIT License