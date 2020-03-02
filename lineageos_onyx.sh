#!/bin/bash

green='\033[01;32m'
restore='\033[0m'

clear

DATE_START=$(date +"%s")

. build/envsetup.sh
breakfast onyx
mka target-files-package otatools

./build/tools/releasetools/sign_target_files_apks -o -d ~/.android-certs \
    $OUT/obj/PACKAGING/target_files_intermediates/*-target_files-*.zip \
    signed-target_files.zip

./build/tools/releasetools/ota_from_target_files -k ~/.android-certs/releasekey \
    --block --backup=true \
    signed-target_files.zip \
    signed-ota_update.zip

mv signed-ota_update.zip lineage-17.1-$(date +%F | sed s@-@@g)-UNOFFICIAL-YumeMichi-onyx.zip

echo -e "${green}"
echo "-------------------"
echo "Build Completed in:"
echo "-------------------"
echo -e "${restore}"

DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo "Time: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo
