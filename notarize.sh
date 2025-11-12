#!/bin/bash

# UniSub Apple 公证脚本
# 用于对 macOS 应用进行 Apple 公证

echo "开始 Apple 公证流程..."

# 设置变量
APP_NAME="UniSub"
APP_VERSION="1.2.0"
BUILD_DIR="build"
DMG_NAME="$APP_NAME-$APP_VERSION.dmg"
ZIP_NAME="$APP_NAME-$APP_VERSION.zip"

# 检查 DMG 文件是否存在
if [ ! -f "$BUILD_DIR/$DMG_NAME" ]; then
    echo "错误: DMG 文件不存在，请先运行 build_dmg.sh"
    exit 1
fi

# 创建 ZIP 文件用于公证（Apple 要求）
echo "创建 ZIP 文件..."
ditto -c -k --keepParent "$BUILD_DIR/$DMG_NAME" "$BUILD_DIR/$ZIP_NAME"

# 获取 Apple ID 和 App-specific 密码
echo "请输入 Apple ID:"
read APPLE_ID

echo "请输入 App-specific 密码:"
read -s APP_PASSWORD

echo "请输入 Team ID:"
read TEAM_ID

# 提交公证请求
echo "提交公证请求..."
xcrun notarytool submit "$BUILD_DIR/$ZIP_NAME" \
    --apple-id "$APPLE_ID" \
    --password "$APP_PASSWORD" \
    --team-id "$TEAM_ID" \
    --wait

# 检查公证结果
if [ $? -eq 0 ]; then
    echo "公证成功!"
    
    # 对 DMG 文件进行 stapling
    echo "对 DMG 文件进行 stapling..."
    xcrun stapler staple "$BUILD_DIR/$DMG_NAME"
    
    echo "公证和 stapling 完成!"
    echo "已公证的 DMG 文件: $BUILD_DIR/$DMG_NAME"
else
    echo "公证失败，请检查错误信息"
    exit 1
fi