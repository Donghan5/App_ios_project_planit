import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/utils/date_formatters.dart';
import '../../data/schedule_repository.dart';
import '../../domain/schedule_item.dart';

// Repository provider
final scheduleRepositoryProvider = Provider<ScheduleRepository>((ref) {
  return ScheduleRepository();
});

// Main list notifier
final scheduleListProvider =
    AsyncNotifierProvider<ScheduleListNotifier, List<ScheduleItem>>(
  ScheduleListNotifier.new,
);

class ScheduleListNotifier extends AsyncNotifier<List<ScheduleItem>> {
  ScheduleRepository get _repo => ref.read(scheduleRepositoryProvider);

  @override
  Future<List<ScheduleItem>> build() => _repo.getAllItems();

  Future<void> addItem(ScheduleItem item) async {
    await _repo.insert(item);
    state = AsyncData(await _repo.getAllItems());
  }

  Future<void> updateItem(ScheduleItem item) async {
    await _repo.update(item);
    state = AsyncData(await _repo.getAllItems());
  }

  Future<void> toggleDone(ScheduleItem item) async {
    final toggled = item.copyWith(isCompleted: !item.isCompleted);
    await _repo.update(toggled);
    state = AsyncData(await _repo.getAllItems());
  }

  Future<void> deleteItem(int id) async {
    await _repo.delete(id);
    state = AsyncData(await _repo.getAllItems());
  }

  Future<void> refresh() async {
    state = AsyncData(await _repo.getAllItems());
  }
}

// Grouped items: List of (sectionTitle, items) sorted by date ascending
typedef GroupedSchedule = List<(String, List<ScheduleItem>)>;

final groupedScheduleProvider = Provider<AsyncValue<GroupedSchedule>>((ref) {
  final itemsAsync = ref.watch(scheduleListProvider);
  return itemsAsync.whenData((items) {
    final grouped = <String, List<ScheduleItem>>{};
    for (final item in items) {
      final key = sectionFormatter.format(item.timestamp);
      grouped.putIfAbsent(key, () => []).add(item);
    }
    final entries = grouped.entries.toList()
      ..sort((a, b) {
        final aDate = a.value.first.timestamp;
        final bDate = b.value.first.timestamp;
        return aDate.compareTo(bDate);
      });
    return entries.map((e) => (e.key, e.value)).toList();
  });
});

// Single item provider derived from the list (auto-refreshes after edits)
final scheduleItemProvider =
    Provider.family<AsyncValue<ScheduleItem?>, int>((ref, id) {
  final listAsync = ref.watch(scheduleListProvider);
  return listAsync.whenData((items) {
    try {
      return items.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  });
});
