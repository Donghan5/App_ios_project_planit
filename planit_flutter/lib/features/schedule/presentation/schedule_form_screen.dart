import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/constants/strings.dart';
import '../../../shared/utils/date_formatters.dart';
import '../domain/schedule_item.dart';
import 'providers/schedule_providers.dart';

class ScheduleFormScreen extends ConsumerStatefulWidget {
  final int? editingId;

  const ScheduleFormScreen({super.key, this.editingId});

  @override
  ConsumerState<ScheduleFormScreen> createState() => _ScheduleFormScreenState();
}

class _ScheduleFormScreenState extends ConsumerState<ScheduleFormScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late DateTime _selectedDate = _nextRoundHour();
  bool _showPastDateWarning = false;
  bool _isLoading = true;
  int _durationMinutes = 60;

  static DateTime _nextRoundHour() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, now.hour + 1);
  }

  static const _durationOptions = [
    (label: '30${Strings.durationMinute}', value: 30),
    (label: '1${Strings.durationHour}', value: 60),
    (label: '1${Strings.durationHour} 30${Strings.durationMinute}', value: 90),
    (label: '2${Strings.durationHour}', value: 120),
  ];

  bool get _isEditing => widget.editingId != null;

  bool get _isTitleValid =>
      _titleController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _loadItem();
  }

  Future<void> _loadItem() async {
    if (_isEditing) {
      final repo = ref.read(scheduleRepositoryProvider);
      final item = await repo.getById(widget.editingId!);
      if (item != null && mounted) {
        _titleController.text = item.title;
        _descriptionController.text = item.descriptionText;
        _selectedDate = item.timestamp;
        _durationMinutes = item.durationMinutes;
        _showPastDateWarning = _selectedDate.isBefore(DateTime.now());
      }
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('ko', 'KR'),
    );
    if (date != null && mounted) {
      setState(() {
        _selectedDate = DateTime(
          date.year,
          date.month,
          date.day,
          _selectedDate.hour,
          _selectedDate.minute,
        );
        _showPastDateWarning = _selectedDate.isBefore(DateTime.now());
      });
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDate),
    );
    if (time != null && mounted) {
      setState(() {
        _selectedDate = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          time.hour,
          time.minute,
        );
        _showPastDateWarning = _selectedDate.isBefore(DateTime.now());
      });
    }
  }

  Future<void> _save() async {
    if (!_isTitleValid) return;

    final item = ScheduleItem(
      id: widget.editingId,
      title: _titleController.text.trim(),
      timestamp: _selectedDate,
      descriptionText: _descriptionController.text,
      durationMinutes: _durationMinutes,
    );

    final notifier = ref.read(scheduleListProvider.notifier);
    if (_isEditing) {
      await notifier.updateItem(item);
    } else {
      await notifier.addItem(item);
    }

    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_isEditing ? Strings.editSchedule : Strings.addSchedule),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? Strings.editSchedule : Strings.addSchedule),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Title field
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: Strings.titleHint,
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
          if (!_isTitleValid)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 12),
              child: Text(
                Strings.titleRequired,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.error,
                    ),
              ),
            ),
          const SizedBox(height: 24),

          // Date picker
          Text(
            Strings.dateLabel,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_today),
                  label: Text(sectionFormatter.format(_selectedDate)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickTime,
                  icon: const Icon(Icons.access_time),
                  label: Text(timeFormatter.format(_selectedDate)),
                ),
              ),
            ],
          ),
          if (_showPastDateWarning)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 12),
              child: Text(
                Strings.pastDateWarning,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.orange,
                    ),
              ),
            ),
          const SizedBox(height: 24),

          // Duration picker
          Text(
            Strings.durationLabel,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _durationOptions.map((option) {
              final selected = _durationMinutes == option.value;
              return ChoiceChip(
                label: Text(option.label),
                selected: selected,
                onSelected: (_) {
                  setState(() => _durationMinutes = option.value);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Description
          Text(
            Strings.descriptionHeader,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _descriptionController,
            maxLines: 5,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 32),

          // Submit button
          FilledButton(
            onPressed: _isTitleValid ? _save : null,
            child: Text(_isEditing ? Strings.submitEdit : Strings.submitAdd),
          ),
        ],
      ),
    );
  }
}
