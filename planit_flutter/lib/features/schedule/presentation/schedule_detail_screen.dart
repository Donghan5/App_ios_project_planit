import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/constants/strings.dart';
import '../../../shared/utils/date_formatters.dart';
import 'providers/schedule_providers.dart';

class ScheduleDetailScreen extends ConsumerWidget {
  final int itemId;

  const ScheduleDetailScreen({super.key, required this.itemId});

  String _formatDuration(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h > 0 && m > 0) return '$h${Strings.durationHour} $m${Strings.durationMinute}';
    if (h > 0) return '$h${Strings.durationHour}';
    return '$m${Strings.durationMinute}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemAsync = ref.watch(scheduleItemProvider(itemId));

    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.scheduleDetail),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => context.push('/form?id=$itemId'),
            child: const Text(Strings.editButton),
          ),
        ],
      ),
      body: itemAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('$err')),
        data: (item) {
          if (item == null) {
            return const Center(child: Text('Item not found'));
          }
          final endTime =
              item.timestamp.add(Duration(minutes: item.durationMinutes));
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        decoration: item.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                ),
                if (item.isCompleted)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Chip(
                      label: const Text(Strings.completedBadge),
                      avatar: const Icon(Icons.check_circle,
                          size: 18, color: Colors.green),
                      backgroundColor:
                          Colors.green.withValues(alpha: 0.1),
                    ),
                  ),
                const SizedBox(height: 12),
                Text(
                  '${Strings.datePrefix}${detailFormatter.format(item.timestamp)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${Strings.durationLabel}: ${_formatDuration(item.durationMinutes)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${Strings.endTimePrefix}${timeFormatter.format(endTime)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                if (item.descriptionText.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    item.descriptionText,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
