#!/bin/bash

# UniSub 应用图标生成脚本
# 从SVG源文件生成所有需要的图标尺寸

echo "开始生成应用图标..."

# 检查是否安装了 rsvg-convert (用于SVG到PNG转换)
if ! command -v rsvg-convert &> /dev/null
then
    echo "警告: 未找到 rsvg-convert，将使用现有的PNG图标"
    echo "请安装 librsvg 以支持SVG到PNG的自动转换:"
    echo "  macOS: brew install librsvg"
else
    echo "找到 rsvg-convert，将从SVG生成图标"
    
    # 创建临时目录
    mkdir -p ../temp_icons

    # 生成不同尺寸的PNG图标
    sizes=(16 32 64 128 256 512 1024)
    
    for size in "${sizes[@]}"
    do
        echo "生成 ${size}x${size} 图标..."
        rsvg-convert -w $size -h $size ../assets/icons/app_icon.svg -o ../temp_icons/app_icon_${size}.png
    done
    
    # 复制生成的图标到应用图标集
    echo "复制图标到应用图标集..."
    for size in "${sizes[@]}"
    do
        cp ../temp_icons/app_icon_${size}.png ../macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_${size}.png
    done
    
    # 清理临时文件
    rm -rf ../temp_icons
    
    echo "图标生成完成！"
fi

echo "请在Xcode中打开项目并确认图标已正确导入。"