import 'package:flutter/material.dart';

import '../../../../shared/constants/strings.dart';
import '../../../../shared/utils/date_formatters.dart';
import '../../domain/schedule_item.dart';

class ScheduleTile extends StatelessWidget {
  final ScheduleItem item;
  final VoidCallback onTap;

  const ScheduleTile({
    super.key,
    required this.item,
    required this.onTap,
  });

  String _formatDuration(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h > 0 && m > 0) return '$h${Strings.durationHour} $m${Strings.durationMinute}';
    if (h > 0) return '$h${Strings.durationHour}';
    return '$m${Strings.durationMinute}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final completed = item.isCompleted;

    return ListTile(
      leading: completed
          ? Icon(Icons.check_circle, color: Colors.green.shade400)
          : null,
      title: Text(
        item.title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              decoration: completed ? TextDecoration.lineThrough : null,
              color: completed ? colorScheme.onSurfaceVariant : null,
            ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${timeFormatter.format(item.timestamp)} · ${_formatDuration(item.durationMinutes)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
          if (item.descriptionText.isNotEmpty)
            Text(
              item.descriptionText,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
        ],
      ),
      onTap: onTap,
    );
  }
}
