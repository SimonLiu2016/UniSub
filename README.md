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

### 9. macOS 原生集成模块

- 菜单栏集成
- Touch Bar 支持
- 系统通知
- 深色模式
- 全局热键

### 10. 模型管理模块

- 按需下载
- 模型切换
- 存储路径

## 系统要求

- macOS 12+ (Apple Silicon & Intel 双架构)
- 8GB RAM (推荐)
- 2GB 可用磁盘空间 (用于模型下载)

## 安装

### 从 App Store 安装

1. 打开 App Store
2. 搜索 "UniSub"
3. 点击 "获取" 安装

### 从官网下载

1. 访问 https://unisub.app
2. 下载 .dmg 安装包
3. 双击安装包并拖拽到 Applications 文件夹

## 使用方法

1. **本地文件处理**:

   - 拖拽视频/音频文件到应用窗口
   - 或点击 "选择文件" 按钮

2. **在线视频处理**:

   - 复制 YouTube/Bilibili 等平台视频链接
   - 粘贴到 URL 输入框并回车

3. **字幕编辑**:

   - 在播放界面点击字幕进行编辑
   - 可修改说话人标签和字幕内容

4. **导出字幕**:
   - 点击导出按钮选择格式
   - 支持 SRT、VTT、ASS 格式

## 隐私政策

UniSub 采用全离线处理模式，所有音频处理和字幕生成均在本地完成，不会上传任何用户数据到服务器。

## 支持的平台

- YouTube
- Bilibili
- X (Twitter)
- TikTok
- Instagram
- Facebook

## 联系我们

- 官网: https://unisub.app
- 邮箱: support@unisub.app
- GitHub: https://github.com/unisub/unisub

## 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情
