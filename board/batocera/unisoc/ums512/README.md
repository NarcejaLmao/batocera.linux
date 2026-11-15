# Anbernic RG Rotate (Unisoc UMS512 / T618)

Kernel: github.com/beebono/linux-mainline-sprd (branch rg-rotate, DTS `sprd/ums512-rg-rotate`).
Bootloader chain: **SPL (github.com/beebono/ums512_spl, flashed to eMMC boot0/boot1)** ->
custom U-Boot from the raw GPT partition labelled `uboot` on the SD card -> `extlinux.conf`
on the BATOCERA FAT partition.

Prerequisites
- The RG Rotate SPL must already be flashed (see rg-rotate-linux README, `tools/spd_dump`).
  It is not built by Batocera (no redistributable build inputs).
- Building the SD image needs `RG_ROTATE_UBOOT_TEMPLATE=<stock uboot_b.img>` in the environment
  to produce the DHTB-wrapped U-Boot for the `uboot` partition. Without it that partition is empty.

Image layout (genimage.cfg): p1 `uboot` (16M raw) | p2 BATOCERA (FAT32) | p3 SHARE (ext4).
Only console: USB gadget serial (ttyGS0). Home/Back combo + USB plug enters FDL.
