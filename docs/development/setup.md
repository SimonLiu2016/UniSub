# 开发环境设置

## 系统要求

- macOS 12+ (Apple Silicon 或 Intel)
- Flutter 3.35+
- Xcode 14+
- Git

## 安装步骤

### 1. 安装 Flutter

```bash
# 使用 Homebrew 安装 Flutter
brew install flutter

# 或从官网下载
# https://docs.flutter.dev/get-started/install/macos
```

### 2. 配置 Flutter

```bash
# 运行 Flutter doctor 检查环境
flutter doctor

# 启用 macOS 支持
flutter config --enable-macos-desktop
```

### 3. 克隆项目

```bash
git clone https://github.com/unisub/unisub.git
cd unisub
```

### 4. 获取依赖

```bash
flutter pub get
```

### 5. 运行应用

```bash
# 开发模式运行
flutter run -d macos

# 或构建发布版本
flutter build macos
```

## 项目结构

```
unisub/
├── lib/                    # Dart 源代码
│   ├── models/            # 数据模型
│   ├── views/             # 页面视图
│   ├── widgets/           # 自定义组件
│   ├── services/          # 业务逻辑服务
│   ├── utils/             # 工具类
│   ├── constants/         # 常量定义
│   └── localization/      # 国际化支持
├── assets/                # 静态资源
│   ├── models/           # AI 模型文件
│   ├── icons/            # 图标资源
│   └── fonts/            # 字体文件
├── macos/                 # macOS 原生代码
├── test/                  # 测试代码
│   ├── unit/             # 单元测试
│   ├── widget/           # 组件测试
│   └── integration/      # 集成测试
├── docs/                  # 文档
└── build/                 # 构建输出
```

## 开发工作流

### 1. 创建新功能分支

```bash
git checkout -b feature/new-feature-name
```

### 2. 编写代码和测试

```bash
# 运行测试
flutter test

# 运行特定测试
flutter test test/unit/subtitle_segment_test.dart
```

### 3. 代码格式化

```bash
# 格式化代码
flutter format .

# 分析代码
flutter analyze
```

### 4. 提交代码

```bash
git add .
git commit -m "Add new feature"
git push origin feature/new-feature-name
```

## 调试技巧

### 1. 日志输出

```dart
import 'package:flutter/foundation.dart';

// 输出调试信息
debugPrint('Debug message');

// 条件调试
if (kDebugMode) {
  print('Debug info');
}
```

### 2. 性能分析

```bash
# 启用性能分析
flutter run --profile

# 打开 DevTools
flutter pub global run devtools
```

## 常见问题

### 1. 依赖问题

```bash
# 清理缓存
flutter pub cache repair

# 重新获取依赖
flutter pub get
```

### 2. 构建问题

```bash
# 清理构建缓存
flutter clean
flutter pub get
```

### 3. macOS 权限问题

确保在 Xcode 中正确配置了应用权限和签名。
