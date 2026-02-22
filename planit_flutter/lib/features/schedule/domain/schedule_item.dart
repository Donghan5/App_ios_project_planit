class ScheduleItem {
  final int? id;
  final String title;
  final DateTime timestamp;
  final String descriptionText;
  final bool isCompleted;
  final int durationMinutes;

  const ScheduleItem({
    this.id,
    required this.title,
    required this.timestamp,
    this.descriptionText = '',
    this.isCompleted = false,
    this.durationMinutes = 60,
  });

  ScheduleItem copyWith({
    int? id,
    String? title,
    DateTime? timestamp,
    String? descriptionText,
    bool? isCompleted,
    int? durationMinutes,
  }) {
    return ScheduleItem(
      id: id ?? this.id,
      title: title ?? this.title,
      timestamp: timestamp ?? this.timestamp,
      descriptionText: descriptionText ?? this.descriptionText,
      isCompleted: isCompleted ?? this.isCompleted,
      durationMinutes: durationMinutes ?? this.durationMinutes,
    );
  }
}
