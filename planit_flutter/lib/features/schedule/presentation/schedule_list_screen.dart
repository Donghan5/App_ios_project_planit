import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/constants/strings.dart';
import '../domain/schedule_item.dart';
import 'providers/schedule_providers.dart';
import 'widgets/date_section_header.dart';
import 'widgets/empty_state_widget.dart';
import 'widgets/schedule_tile.dart';

class ScheduleListScreen extends ConsumerStatefulWidget {
  const ScheduleListScreen({super.key});

  @override
  ConsumerState<ScheduleListScreen> createState() =>
      _ScheduleListScreenState();
}

class _ScheduleListScreenState extends ConsumerState<ScheduleListScreen> {
  void _showUndoSnackBar(String message, VoidCallback onUndo) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: Strings.undoButton,
          onPressed: onUndo,
        ),
      ),
    );
  }

  Future<bool?> _confirmDismiss(
    DismissDirection direction,
    ScheduleItem item,
  ) async {
    if (direction == DismissDirection.startToEnd) {
      // Swipe right → mark done
      final notifier = ref.read(scheduleListProvider.notifier);
      await notifier.toggleDone(item);
      _showUndoSnackBar(
        Strings.undoDoneMessage,
        () => notifier.toggleDone(item.copyWith(isCompleted: !item.isCompleted)),
      );
      return false; // Don't remove from list
    }
    // Swipe left → delete
    return true;
  }

  void _onDismissed(ScheduleItem item) {
    final notifier = ref.read(scheduleListProvider.notifier);
    notifier.deleteItem(item.id!);
    _showUndoSnackBar(
      Strings.undoDeleteMessage,
      () => notifier.addItem(item),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupedAsync = ref.watch(groupedScheduleProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.scheduleList),
      ),
      body: groupedAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('$err')),
        data: (grouped) {
          if (grouped.isEmpty) {
            return const EmptyStateWidget();
          }
          return ListView.builder(
            itemCount: grouped.fold<int>(
              0,
              (sum, section) => sum + 1 + section.$2.length,
            ),
            itemBuilder: (context, index) {
              var remaining = index;
              for (final (sectionTitle, items) in grouped) {
                if (remaining == 0) {
                  return DateSectionHeader(title: sectionTitle);
                }
                remaining--;
                if (remaining < items.length) {
                  final item = items[remaining];
                  return Dismissible(
                    key: ValueKey(item.id),
                    direction: DismissDirection.horizontal,
                    background: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      color: Colors.green,
                      child: Row(
                        children: [
                          Icon(Icons.check, color: colorScheme.onPrimary),
                          const SizedBox(width: 8),
                          Text(
                            Strings.markDoneLabel,
                            style: TextStyle(color: colorScheme.onPrimary),
                          ),
                        ],
                      ),
                    ),
                    secondaryBackground: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: colorScheme.error,
                      child: Text(
                        Strings.deleteLabel,
                        style: TextStyle(color: colorScheme.onError),
                      ),
                    ),
                    confirmDismiss: (direction) =>
                        _confirmDismiss(direction, item),
                    onDismissed: (_) => _onDismissed(item),
                    child: ScheduleTile(
                      item: item,
                      onTap: () => context.push('/detail/${item.id}'),
                    ),
                  );
                }
                remaining -= items.length;
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/form'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
