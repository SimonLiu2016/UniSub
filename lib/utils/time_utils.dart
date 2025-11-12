class TimeUtils {
  /// 将秒数格式化为 HH:MM:SS,mmm 格式 (SRT/VTT格式)
  static String formatTimeSrt(double seconds) {
    final duration = Duration(milliseconds: (seconds * 1000).round());
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final secs = duration.inSeconds.remainder(60);
    final millis = duration.inMilliseconds.remainder(1000);

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')},${millis.toString().padLeft(3, '0')}';
  }

  /// 将秒数格式化为 H:MM:SS.cc 格式 (ASS格式)
  static String formatTimeAss(double seconds) {
    final duration = Duration(milliseconds: (seconds * 1000).round());
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final secs = duration.inSeconds.remainder(60);
    final centis = (duration.inMilliseconds.remainder(1000) / 10).round();

    return '${hours.toString()}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}.${centis.toString().padLeft(2, '0')}';
  }

  /// 将秒数格式化为 HH:MM:SS 格式
  static String formatTimeHms(double seconds) {
    final duration = Duration(milliseconds: (seconds * 1000).round());
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final secs = duration.inSeconds.remainder(60);

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  /// 将秒数格式化为 M:SS 格式 (用于时间轴显示)
  static String formatTimeMs(double seconds) {
    final duration = Duration(milliseconds: (seconds * 1000).round());
    final minutes = duration.inMinutes;
    final secs = duration.inSeconds.remainder(60);

    return '${minutes}:${secs.toString().padLeft(2, '0')}';
  }

  /// 将 HH:MM:SS,mmm 格式的时间字符串转换为秒数
  static double parseTimeSrt(String timeString) {
    final parts = timeString.split(':');
    if (parts.length != 3) return 0.0;

    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    final secParts = parts[2].split(',');
    final seconds = int.parse(secParts[0]);
    final millis = int.parse(secParts[1]);

    return hours * 3600 + minutes * 60 + seconds + millis / 1000;
  }

  /// 将 H:MM:SS.cc 格式的时间字符串转换为秒数
  static double parseTimeAss(String timeString) {
    final parts = timeString.split(':');
    if (parts.length != 3) return 0.0;

    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    final secParts = parts[2].split('.');
    final seconds = int.parse(secParts[0]);
    final centis = int.parse(secParts[1]);

    return hours * 3600 + minutes * 60 + seconds + centis / 100;
  }
}
