import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/cubit/note_cubit.dart';
import 'package:note_app/model/event_model.dart';
import 'package:note_app/theme.dart';

const _days = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];
const _months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});
  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  DateTime _selected = DateTime.now();

  void _openSheet() => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => _EventSheet(_selected),
  );

  @override
  Widget build(BuildContext context) => SafeArea(
    child: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Events',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        CalendarDatePicker(
          initialDate: _selected,
          firstDate: DateTime(2020),
          lastDate: DateTime(2035),
          onDateChanged: (d) => setState(() => _selected = d),
        ),
        Text(
          _days[_selected.weekday - 1],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          '${_selected.day} ${_months[_selected.month - 1]}, ${_selected.year}',
          style: const TextStyle(color: AppColors.grey),
        ),
        const SizedBox(height: 8),
        BlocBuilder<EventCubit, List<Event>>(
          builder: (context, events) {
            final key = dateKey(_selected);
            final dayEvents = events.where((e) => e.date == key).toList();
            if (dayEvents.isEmpty) {
              return const Text(
                'No events for this day',
                style: TextStyle(color: AppColors.grey),
              );
            }
            return Column(children: [for (final e in dayEvents) _EventTile(e)]);
          },
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _openSheet,
          child: const Text('Create New Event'),
        ),
      ],
    ),
  );
}

class _EventTile extends StatelessWidget {
  final Event event;
  const _EventTile(this.event);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Dismissible(
      key: ValueKey(event.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => context.read<EventCubit>().remove(event.id!),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFFF3B30),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFE3EEFF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  event.time,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    event.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            if (event.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  event.description,
                  style: const TextStyle(fontSize: 12, color: AppColors.grey),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

class _EventSheet extends StatefulWidget {
  final DateTime date;
  const _EventSheet(this.date);
  @override
  State<_EventSheet> createState() => _EventSheetState();
}

class _EventSheetState extends State<_EventSheet> {
  final _title = TextEditingController();
  final _desc = TextEditingController();
  TimeOfDay _time = TimeOfDay.now();

  String get _timeText =>
      '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}';

  Future<void> _pickTime() async {
    final t = await showTimePicker(context: context, initialTime: _time);
    if (t != null) setState(() => _time = t);
  }

  void _save() {
    if (_title.text.trim().isEmpty) return;
    context.read<EventCubit>().add(
      Event(
        title: _title.text.trim(),
        description: _desc.text.trim(),
        date: dateKey(widget.date),
        time: _timeText,
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(
      16,
      16,
      16,
      16 + MediaQuery.of(context).viewInsets.bottom,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Create New Event',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _title,
          decoration: const InputDecoration(
            labelText: 'Title',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _desc,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: _pickTime,
          icon: const Icon(Icons.access_time),
          label: Text(_timeText),
        ),
        const SizedBox(height: 10),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    ),
  );
}
