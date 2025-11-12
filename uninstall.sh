#!/system/bin/sh
MODDIR=${0%/*}
INFO=/modules/.S23U-files
MODID=S23U
LIBDIR=/system
MODPATH=$MODDIR
MODDIR=${0%/*}
INFO=/modules/.S23U-files
MODID=S23U
LIBDIR=/system
MODPATH=$MODDIR
MODDIR=${0%/*}
for dir in $(find "$MODDIR/system" -mindepth 1 -maxdepth 1 -type d); do
  name=$(basename "$dir")
  target="/system/$name"
  if [ -d "$target" ]; then
    for item in "$dir"/*; do
      umount "$target/$(basename "$item")" 2>/dev/null
    done
  fi
done

