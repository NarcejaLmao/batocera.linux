#!/bin/bash

# HOST_DIR = host dir
# BOARD_DIR = board specific dir
# BUILD_DIR = base dir/build
# BINARIES_DIR = images dir
# TARGET_DIR = target dir
# BATOCERA_BINARIES_DIR = batocera binaries sub directory

HOST_DIR=$1
BOARD_DIR=$2
BUILD_DIR=$3
BINARIES_DIR=$4
TARGET_DIR=$5
BATOCERA_BINARIES_DIR=$6

mkdir -p "${BATOCERA_BINARIES_DIR}/boot/boot" "${BATOCERA_BINARIES_DIR}/boot/extlinux" || exit 1

echo "*** Copying the Batocera base system files ***"
cp "${BINARIES_DIR}/rootfs.squashfs" "${BATOCERA_BINARIES_DIR}/boot/boot/batocera.update" || exit 1
cp "${BINARIES_DIR}/rufomaculata"    "${BATOCERA_BINARIES_DIR}/boot/boot/rufomaculata.update" || exit 1
cp "${BINARIES_DIR}/Image"           "${BATOCERA_BINARIES_DIR}/boot/boot/linux" || exit 1
cp "${BINARIES_DIR}/initrd.lz4"      "${BATOCERA_BINARIES_DIR}/boot/boot/initrd.lz4" || exit 1
cp "${BINARIES_DIR}/ums512-rg-rotate.dtb" "${BATOCERA_BINARIES_DIR}/boot/boot/" || exit 1

echo "*** Generating extlinux.conf (read by the RG Rotate U-Boot) ***"
cat > "${BATOCERA_BINARIES_DIR}/boot/extlinux/extlinux.conf" <<EOC || exit 1
DEFAULT batocera
TIMEOUT 0

LABEL batocera
    KERNEL /boot/linux
    INITRD /boot/initrd.lz4
    FDT /boot/ums512-rg-rotate.dtb
    APPEND label=BATOCERA rootwait quiet loglevel=0 console=tty3 vt.global_cursor_default=0
EOC

# The SPL loads U-Boot from the raw "uboot" GPT partition. That image is U-Boot wrapped in the
# Unisoc DHTB header, which is taken from a stock RG Rotate uboot image (not redistributable).
# Provide it with:  RG_ROTATE_UBOOT_TEMPLATE=/path/to/stock/uboot_b.img
# Docker builds do not inherit env vars, so a template dropped next to this script is used too
[ -z "${RG_ROTATE_UBOOT_TEMPLATE}" ] && [ -f "${BOARD_DIR}/uboot_template.img" ] && RG_ROTATE_UBOOT_TEMPLATE="${BOARD_DIR}/uboot_template.img"
UBOOT_PAYLOAD="${BINARIES_DIR}/rg-rotate/u-boot-dtb.bin"
if [ -n "${RG_ROTATE_UBOOT_TEMPLATE}" ] && [ -f "${RG_ROTATE_UBOOT_TEMPLATE}" ] && [ -f "${UBOOT_PAYLOAD}" ]; then
    echo "*** Packing U-Boot into the DHTB wrapper ***"
    python3 "${BINARIES_DIR}/rg-rotate/pack_unisoc_uboot.py" \
        "${RG_ROTATE_UBOOT_TEMPLATE}" "${UBOOT_PAYLOAD}" "${BINARIES_DIR}/uboot.img" || exit 1
else
    echo "WARNING: RG_ROTATE_UBOOT_TEMPLATE not set, 'uboot' partition left empty."
    echo "         Set it to a stock uboot_b.img dump, or write the packed U-Boot to the partition later."
    truncate -s 16M "${BINARIES_DIR}/uboot.img" || exit 1
fi

exit 0
