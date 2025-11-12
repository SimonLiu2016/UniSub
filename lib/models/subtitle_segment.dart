class SubtitleSegment {
  final int id;
  final double startTime;
  final double endTime;
  final String text;
  final String speaker;

  SubtitleSegment({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.text,
    required this.speaker,
  });

  factory SubtitleSegment.fromJson(Map<String, dynamic> json) {
    return SubtitleSegment(
      id: json['id'] as int,
      startTime: (json['start_time'] as num).toDouble(),
      endTime: (json['end_time'] as num).toDouble(),
      text: json['text'] as String,
      speaker: json['speaker'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start_time': startTime,
      'end_time': endTime,
      'text': text,
      'speaker': speaker,
    };
  }

  @override
  String toString() {
    return 'SubtitleSegment(id: $id, startTime: $startTime, endTime: $endTime, text: $text, speaker: $speaker)';
  }
}
