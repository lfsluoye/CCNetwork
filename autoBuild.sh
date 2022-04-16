#!/bin/bash

FRAMEWORK_NAME='CCNetwork'

WORK_DIR='build'

#release环境下，generic ios device编译出的framework。这个framework只能供真机运行。
DEVICE_DIR=${WORK_DIR}/'UninstalledProducts'/'iphoneos'/${FRAMEWORK_NAME}'.framework'

#release环境下，simulator编译出的framework。这个framework只能供模拟器运行。
SIMULATOR_DIR=${WORK_DIR}/'UninstalledProducts'/'iphonesimulator'/${FRAMEWORK_NAME}'.framework'

#framework的输出目录
OUTPUT_DIR=./'AProducts'

// ios release
xcodebuild archive \
-target ${FRAMEWORK_NAME} \
-destination="iOS" -sdk iphoneos \
-configuration Release\
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES\

#// ios simulator release
xcodebuild archive \
-target ${FRAMEWORK_NAME} \
-destination="iOS Simulator"  -sdk iphonesimulator \
-configuration Release\
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES

#如果输出目录存在，即移除该目录，再创建该目录。目的是为了清空输出目录。
if [ -d ${OUTPUT_DIR}/${FRAMEWORK_NAME}.xcframework ]; then
rm -rf ${OUTPUT_DIR}/${FRAMEWORK_NAME}.xcframework
fi

#将打包好的framwork合并成xcframework
xcodebuild -create-xcframework \
-framework ${DEVICE_DIR} \
-framework ${SIMULATOR_DIR} \
-output ${OUTPUT_DIR}/${FRAMEWORK_NAME}.xcframework

#删除临时目录
rm -r ${WORK_DIR}
#打开输出目录
open ${OUTPUT_DIR}
