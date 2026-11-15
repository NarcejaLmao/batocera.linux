#!/bin/bash
# Remove every device/target from the tree except the Anbernic RG Rotate (ums512).
# Shared files (board/batocera/{fsoverlay,patches,scripts,users.txt,...}) are kept.
set -e
cd "$(dirname "$0")/.."

# board definitions: keep ums512 and the shared common file/helpers
find configs -maxdepth 1 -name 'batocera-*.board' ! -name 'batocera-ums512.board' -delete
rm -f configs/batocera-x86_defconfig.disabled

# per-device board directories: keep unisoc (RG Rotate) only
for d in allwinner amlogic broadcom qualcomm rockchip samsung starfive x86 x86-64-v3 x86_64; do
    rm -rf "board/batocera/$d"
done

echo "Remaining targets:"; ls configs/*.board
echo "Remaining device dirs:"; ls board/batocera
