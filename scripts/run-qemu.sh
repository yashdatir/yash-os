# ==============================
# Yash OS 1.0 – QEMU Boot Script
# ==============================

echo
echo "🐧 Welcome to Yash Datir's OS 1.0"
echo "--------------------------------------------"

#!/bin/bash
set -e

# -------- CONFIG --------
IMAGE_DIR="$(pwd)/build"
KERNEL="$IMAGE_DIR/bzImage"
ROOTFS_TAR="$IMAGE_DIR/rootfs.tar"
ROOTFS_IMG="$IMAGE_DIR/rootfs.ext4"
MOUNT_DIR="/tmp/br-rootfs-mnt"
DISK_SIZE_MB=256
RAM_MB=128
# ------------------------

echo "==> Checking files..."
[ -f "$KERNEL" ] || { echo "bzImage not found"; exit 1; }
[ -f "$ROOTFS_TAR" ] || { echo "rootfs.tar not found"; exit 1; }

# Create rootfs image if not exists
if [ ! -f "$ROOTFS_IMG" ]; then
  echo "==> Creating ext4 root filesystem image..."
  dd if=/dev/zero of="$ROOTFS_IMG" bs=1M count=$DISK_SIZE_MB
  mkfs.ext4 "$ROOTFS_IMG"

  mkdir -p "$MOUNT_DIR"
  sudo mount "$ROOTFS_IMG" "$MOUNT_DIR"

  echo "==> Extracting rootfs..."
  sudo tar -xf "$ROOTFS_TAR" -C "$MOUNT_DIR"
  sync

  sudo umount "$MOUNT_DIR"
  rmdir "$MOUNT_DIR"

  echo "==> Root filesystem ready"
else
  echo "==> Root filesystem image already exists"
fi

echo "==> Starting QEMU..."
qemu-system-x86_64 \
  -kernel "$KERNEL" \
  -drive file="$ROOTFS_IMG",format=raw \
  -append "root=/dev/sda rw console=tty0 loglevel=8" \
  -m 1024

echo "🛑 QEMU exited cleanly"
