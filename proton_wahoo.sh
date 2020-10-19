#!/bin/bash

green='\033[01;32m'
restore='\033[0m'

clear

DATE_START=$(date +"%s")

. build/envsetup.sh
lunch aosp_taimen-userdebug
make -j$(nproc) dist

ln -sf out/host/linux-x86/framework build/tools/framework
ln -sf out/host/linux-x86/lib64 build/tools/lib64

./build/tools/releasetools/sign_target_files_apks -o -d ~/.android-certs \
    out/dist/*-target_files-*.zip \
    signed-target_files.zip

./build/tools/releasetools/ota_from_target_files -k ~/.android-certs/releasekey \
    signed-target_files.zip \
    signed-ota_update.zip

mv signed-ota_update.zip aosp_taimen-$(date +%F | sed s@-@@g)-YumeMichi.zip

echo -e "${green}"
echo "-------------------"
echo "Build Completed in:"
echo "-------------------"
echo -e "${restore}"

DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo "Time: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo
