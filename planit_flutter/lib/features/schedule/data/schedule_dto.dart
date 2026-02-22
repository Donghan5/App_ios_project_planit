import '../domain/schedule_item.dart';

class ScheduleDto {
  static ScheduleItem fromMap(Map<String, dynamic> map) {
    return ScheduleItem(
      id: map['id'] as int,
      title: map['title'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String).toLocal(),
      descriptionText: (map['description_text'] as String?) ?? '',
      isCompleted: (map['is_completed'] as int? ?? 0) == 1,
      durationMinutes: (map['duration_minutes'] as int?) ?? 60,
    );
  }

  static Map<String, dynamic> toMap(ScheduleItem item) {
    return {
      if (item.id != null) 'id': item.id,
      'title': item.title,
      'timestamp': item.timestamp.toUtc().toIso8601String(),
      'description_text': item.descriptionText,
      'is_completed': item.isCompleted ? 1 : 0,
      'duration_minutes': item.durationMinutes,
    };
  }
}
