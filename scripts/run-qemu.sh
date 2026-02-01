# ==============================
# Yash OS 1.0 – QEMU Boot Script
# ==============================

# Source artifacts
KERNEL_IMAGE="kernel/bzImage"
ROOTFS_TAR="rootfs/rootfs.tar"
EXTLINUX_CFG="configs/extlinux.conf"

# Build workspace
BUILD_DIR="build"
DISK_IMAGE="$BUILD_DIR/yashos.img"
MOUNT_DIR="$BUILD_DIR/mounted"
DISTRO_DIR="$BUILD_DIR/distro"

# Config
DISK_SIZE="100M"
MEMORY="4G"

echo
echo "🐧 Welcome to Yash OS 1.0"
echo "--------------------------------------------"

# Sanity checks
for file in "$KERNEL_IMAGE" "$ROOTFS_TAR" "$EXTLINUX_CFG"; do
  if [[ ! -f "$file" ]]; then
    echo "❌ Missing required file: $file"
    exit 1
  fi
done

# Prepare build directory
mkdir -p "$BUILD_DIR"

# Cleanup on exit
cleanup() {
  sudo umount "$MOUNT_DIR" 2>/dev/null || true
  rm -rf "$MOUNT_DIR" "$DISTRO_DIR"
}
trap cleanup EXIT

echo "📦 Preparing root filesystem..."
mkdir -p "$DISTRO_DIR"
cp "$KERNEL_IMAGE" "$ROOTFS_TAR" "$DISTRO_DIR"
tar -xf "$ROOTFS_TAR" -C "$DISTRO_DIR"

echo "💽 Creating disk image ($DISK_SIZE)..."
truncate -s "$DISK_SIZE" "$DISK_IMAGE"
mkfs.ext4 -F "$DISK_IMAGE" > /dev/null

echo "🔧 Installing bootloader (EXTLINUX)..."
mkdir -p "$MOUNT_DIR"
sudo mount "$DISK_IMAGE" "$MOUNT_DIR"

sudo extlinux --install "$MOUNT_DIR"
sudo mkdir -p "$MOUNT_DIR/extlinux"
sudo cp "$EXTLINUX_CFG" "$MOUNT_DIR/extlinux/extlinux.conf"

sudo cp -r "$DISTRO_DIR"/* "$MOUNT_DIR"
sudo umount "$MOUNT_DIR"

echo "🚀 Booting Yash OS in QEMU..."
qemu-system-x86_64 \
  -enable-kvm \
  -m "$MEMORY" \
  -nic user,model=virtio-net-pci \
  -drive file="$DISK_IMAGE",format=raw \
  -nographic

echo "🛑 QEMU exited cleanly"
