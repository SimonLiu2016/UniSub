#!/bin/bash

# UniSub 打包脚本
# 用于构建 macOS .dmg 安装包

echo "开始构建 UniSub macOS 应用..."

# 设置变量
APP_NAME="UniSub"
APP_VERSION="1.2.0"
BUILD_DIR="build"
APP_DIR="$BUILD_DIR/macos/Build/Products/Release"
DMG_DIR="$BUILD_DIR/dmg"
DMG_NAME="$APP_NAME-$APP_VERSION.dmg"

# 清理之前的构建
echo "清理之前的构建..."
flutter clean
rm -rf $BUILD_DIR

# 构建 macOS 应用
echo "构建 macOS 应用..."
flutter build macos --release

# 检查构建是否成功
if [ ! -d "$APP_DIR/$APP_NAME.app" ]; then
    echo "错误: 应用构建失败"
    exit 1
fi

# 创建 DMG 目录
echo "创建 DMG 目录..."
mkdir -p $DMG_DIR

# 复制应用到 DMG 目录
echo "复制应用到 DMG 目录..."
cp -R "$APP_DIR/$APP_NAME.app" $DMG_DIR/

# 创建软链接到 Applications
echo "创建 Applications 软链接..."
ln -s /Applications $DMG_DIR/Applications

# 创建 DMG
echo "创建 DMG 文件..."
hdiutil create -volname "$APP_NAME $APP_VERSION" \
    -srcfolder $DMG_DIR \
    -ov \
    -format UDZO \
    $BUILD_DIR/$DMG_NAME

# 清理临时目录
echo "清理临时目录..."
rm -rf $DMG_DIR

echo "构建完成!"
echo "DMG 文件位置: $BUILD_DIR/$DMG_NAME"