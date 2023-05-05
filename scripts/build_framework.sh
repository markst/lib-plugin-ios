#!/bin/sh
set -e

WORKSPACE="YouboraLib.xcworkspace"
SCHEME="YouboraLib iOS"
FRAMEWORK_NAME="YouboraLib"

BUILD_DIR="Build"
TMP_DIR="${BUILD_DIR}/Tmp"
IOS_ARCHIVE_PATH="${TMP_DIR}/iOS.xcarchive"
IOS_SIM_ARCHIVE_PATH="${TMP_DIR}/iOSSimulator.xcarchive"

TVOS_SCHEME="YouboraLib tvOS"
TVOS_ARCHIVE_PATH="${TMP_DIR}/tvOS.xcarchive"
TVOS_SIM_ARCHIVE_PATH="${TMP_DIR}/tvOSSimulator.xcarchive"

rm -rf ${BUILD_DIR}
rm -rf "${FRAMEWORK_NAME}.xcframework"

xcodebuild archive \
    -workspace "${WORKSPACE}" \
    -scheme "${SCHEME}" \
    -archivePath ${IOS_SIM_ARCHIVE_PATH} \
    -sdk iphonesimulator \
    SKIP_INSTALL=NO

xcodebuild archive \
    -workspace "${WORKSPACE}" \
    -scheme "${SCHEME}" \
    -archivePath ${IOS_ARCHIVE_PATH} \
    -sdk iphoneos \
    SKIP_INSTALL=NO

xcodebuild archive \
    -workspace "${WORKSPACE}" \
    -scheme "${TVOS_SCHEME}" \
    -archivePath ${TVOS_SIM_ARCHIVE_PATH} \
    -sdk appletvsimulator \
    SKIP_INSTALL=NO

xcodebuild archive \
    -workspace "${WORKSPACE}" \
    -scheme "${TVOS_SCHEME}" \
    -archivePath ${TVOS_ARCHIVE_PATH} \
    -sdk appletvos \
    SKIP_INSTALL=NO

xcodebuild -create-xcframework \
    -framework ${IOS_SIM_ARCHIVE_PATH}/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework \
    -framework ${IOS_ARCHIVE_PATH}/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework \
    -framework ${TVOS_SIM_ARCHIVE_PATH}/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework \
    -framework ${TVOS_ARCHIVE_PATH}/Products/Library/Frameworks/${FRAMEWORK_NAME}.framework \
    -output ${FRAMEWORK_NAME}.xcframework

: '
zip ${FRAMEWORK_NAME}.xcframework.zip ${FRAMEWORK_NAME}.xcframework

rm -rf ${BUILD_DIR}

swift package compute-checksum ${FRAMEWORK_NAME}.xcframework.zip
'