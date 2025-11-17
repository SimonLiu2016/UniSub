# UniSub 字幕生成器 (macOS 版)

UniSub 是一款全离线优先 + 在线视频兼容的原生 AI 字幕生成工具，专为 macOS 平台设计。

## 核心功能

- **离线优先**: 所有 AI 推理（转写、翻译）本地完成，保护用户隐私
- **在线无缝**: 粘贴链接 → 自动下载音频 → 转写 → 播放全流程自动化
- **原生体验**: 适配菜单栏、Touch Bar、深色模式、拖拽、右键菜单等 macOS 特性
- **国际化**: 支持 zh-TW（默认）、zh-CN、en、ja、ko 5 种语言
- **App Store 合规**: 启用沙盒、模型按需下载、隐私透明化

## 技术栈

- Flutter Desktop
- whisper.cpp (语音转写)
- yt-dlp (在线视频下载)
- video_player_macos (视频播放)
- FFI (本地库调用)
- i18n (国际化)

## 安装要求

### 系统要求

- macOS 10.15 或更高版本

### 依赖项

- yt-dlp: 用于在线视频音频提取
- Homebrew (推荐): 用于简化依赖安装

### 安装 yt-dlp

#### 使用 Homebrew (推荐)

```bash
# 安装 Homebrew (如果尚未安装)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 安装 yt-dlp
brew install yt-dlp
```

#### 使用 pip

```bash
pip install yt-dlp
```

#### 手动下载

访问 [yt-dlp GitHub releases](https://github.com/yt-dlp/yt-dlp/releases) 下载最新版本

## 功能模块

### 1. 输入支持模块

- 拖拽支持
- 文件选择
- 右键菜单集成
- 在线 URL 输入
- 剪贴板监控

### 2. 在线视频处理模块

- URL 解析
- 合法性校验
- 音频流下载
- 临时缓存
- 进度反馈
- 自动播放
- 错误处理

### 3. 视频播放与字幕同步模块

- 原生播放器
- 字幕自动加载
- 点击跳转
- 字幕样式自定义
- 硬字幕预览

### 4. 语音转写（ASR）模块

- 模型支持 (base, small, medium, large-v3)
- 语言检测
- 精确时间戳
- 标点与大小写

### 5. 说话人识别（Diarization）模块

- 自动聚类
- 标签映射
- 手动编辑

### 6. 翻译功能模块

- 翻译模型 (NLLB-200-distilled-600M)
- 支持语言 (英 → 繁中、日 → 繁中、韩 → 繁中等)
- 实时翻译
- 预翻译
- 翻译后处理

### 7. 字幕输出模块

- 格式支持 (srt, vtt, ass)
- 实时预览
- 导出路径
- 分享功能

### 8. 国际化模块

- 支持语言 (zh-TW, zh-CN, en, ja, ko)
- 动态切换
- 系统跟随

## 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情
