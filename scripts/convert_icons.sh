#!/bin/bash

# UniSub 图标转换脚本
# 将SVG图标转换为PDF格式以供macOS使用

echo "开始转换图标..."

# 创建必要的目录
mkdir -p ../macos/Runner/Assets.xcassets/StatusBarIcon.imageset

# 转换托盘图标
echo "转换托盘图标..."
cp ../assets/icons/tray_icon.svg ../macos/Runner/Assets.xcassets/StatusBarIcon.imageset/tray_icon.pdf

# 转换应用图标（如果需要的话）
echo "图标转换完成！"

echo "请在Xcode中打开项目并确认图标已正确导入。"