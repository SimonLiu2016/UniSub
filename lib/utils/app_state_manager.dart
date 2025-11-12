import 'package:flutter/foundation.dart';

class AppStateManager extends ChangeNotifier {
  // 应用状态
  bool _isProcessing = false;
  double _processingProgress = 0.0;
  String _processingStatus = '';

  // 应用设置
  String _language = 'zh_TW';
  String _theme = 'system';
  String _model = 'medium';

  // 字幕相关
  bool _isPlaying = false;
  int _currentSubtitleIndex = -1;

  // 网络状态
  bool _isOnline = true;
  bool _isDownloading = false;

  // Getters
  bool get isProcessing => _isProcessing;
  double get processingProgress => _processingProgress;
  String get processingStatus => _processingStatus;
  String get language => _language;
  String get theme => _theme;
  String get model => _model;
  bool get isPlaying => _isPlaying;
  int get currentSubtitleIndex => _currentSubtitleIndex;
  bool get isOnline => _isOnline;
  bool get isDownloading => _isDownloading;

  // Setters with notification
  set isProcessing(bool value) {
    _isProcessing = value;
    notifyListeners();
  }

  set processingProgress(double value) {
    _processingProgress = value;
    notifyListeners();
  }

  set processingStatus(String value) {
    _processingStatus = value;
    notifyListeners();
  }

  set language(String value) {
    _language = value;
    notifyListeners();
  }

  set theme(String value) {
    _theme = value;
    notifyListeners();
  }

  set model(String value) {
    _model = value;
    notifyListeners();
  }

  set isPlaying(bool value) {
    _isPlaying = value;
    notifyListeners();
  }

  set currentSubtitleIndex(int value) {
    _currentSubtitleIndex = value;
    notifyListeners();
  }

  set isOnline(bool value) {
    _isOnline = value;
    notifyListeners();
  }

  set isDownloading(bool value) {
    _isDownloading = value;
    notifyListeners();
  }

  // 方法
  void startProcessing(String status) {
    isProcessing = true;
    processingStatus = status;
    processingProgress = 0.0;
  }

  void updateProgress(double progress, [String? status]) {
    processingProgress = progress;
    if (status != null) {
      processingStatus = status;
    }
  }

  void finishProcessing() {
    isProcessing = false;
    processingProgress = 1.0;
    processingStatus = '完成';
  }

  void togglePlay() {
    isPlaying = !isPlaying;
  }

  void setCurrentSubtitle(int index) {
    currentSubtitleIndex = index;
  }

  void reset() {
    _isProcessing = false;
    _processingProgress = 0.0;
    _processingStatus = '';
    _isPlaying = false;
    _currentSubtitleIndex = -1;
    _isDownloading = false;
    notifyListeners();
  }
}
