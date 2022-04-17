#!/bin/bash
set -e

currentFold="$( cd "$( dirname "$0"  )" && pwd  )"   # 脚本当前目录
fatherFold=$(dirname $currentFold)                   # 父目录

build=${currentFold}/build
OUTPUT_DIR=${currentFold}/AProducts
rm -rf $build
rm -rf $OUTPUT_DIR
rm -rf ./Pods
rm ./Podfile.lock
mkdir $build
mkdir $OUTPUT_DIR

pod install
#获取scheme名字
workspace=`ls | grep *.xcworkspace`
# Release
workspacePath=$currentFold/$workspace   #工程文件目录
scheme=${workspace%.*}
frameworkName=$scheme
configuration="Release"
devicce_dir="${build}/${configuration}-iphonesimulator/${frameworkName}.framework"
simulator_dir="${build}/${configuration}-iphoneos/${frameworkName}.framework"

# xcodebuild打包
xcodebuild -workspace $workspacePath -scheme ${scheme} -configuration ${configuration} -sdk iphoneos BITCODE_GENERATION_MODE=bitcode OTHER_CFLAGS="-fembed-bitcode" BUILD_DIR=$build BUILD_ROOT=$build  clean build
xcodebuild -workspace $workspacePath -scheme ${scheme} -configuration ${configuration} -sdk iphonesimulator BITCODE_GENERATION_MODE=bitcode OTHER_CFLAGS="-fembed-bitcode" BUILD_DIR=$build BUILD_ROOT=$build  clean build
cp -rf ${build}/${configuration}-iphoneos/${frameworkName}.framework ${build}/${frameworkName}.framework
 swiftmodulePath=${build}/${configuration}-iphonesimulator/${frameworkName}.framework/Modules/${frameworkName}.swiftmodule
if [ -d ${swiftmodulePath} ];then
 cp -rf ${build}/${configuration}-iphonesimulator/${frameworkName}.framework/Modules/${frameworkName}.swiftmodule/* ${build}/${frameworkName}.framework/Modules/${frameworkName}.swiftmodule/
fi

#如果输出目录存在，即移除该目录，再创建该目录。目的是为了清空输出目录。
if [ -d ${OUTPUT_DIR}/${frameworkName}.xcframework ]; then
rm -rf ${OUTPUT_DIR}/${frameworkName}.xcframework
fi

#将打包好的framwork合并成xcframework
xcodebuild -create-xcframework \
-framework ${devicce_dir} \
-framework ${simulator_dir} \
-output ${OUTPUT_DIR}/${frameworkName}.xcframework

# lipo -create  "${build}/${configuration}-iphonesimulator/${frameworkName}.framework/${frameworkName}" "${build}/${configuration}-iphoneos/${frameworkName}.framework/${frameworkName}" -output "${build}/${frameworkName}"
# cp -rf ${build}/${frameworkName} ${build}/${frameworkName}.framework/${frameworkName}

rm -rf ${build}/${configuration}-iphonesimulator
rm -rf ${build}/${configuration}-iphoneos
rm -rf ${build}/${frameworkName}
