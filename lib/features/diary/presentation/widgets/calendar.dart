import 'package:deardiaryv2/features/diary/domain/entities/diary_entry.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class DiaryCalendar extends StatefulWidget {
  final List<DiaryEntry> diaries;
  final void Function(DiaryEntry? entry) onDaySelected;

  const DiaryCalendar({
    super.key,
    required this.diaries,
    required this.onDaySelected,
  });

  @override
  State<DiaryCalendar> createState() => _DiaryCalendarState();
}

class _DiaryCalendarState extends State<DiaryCalendar> {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();

  late final Map<DateTime, DiaryEntry> _diaryMap;

  DateTime _normalize(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  @override
  void initState() {
    super.initState();

    _diaryMap = {
      for (var entry in widget.diaries) _normalize(entry.createdAt): entry,
    };
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: 500,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        color: scheme.surface,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: TableCalendar(
          firstDay: DateTime(2020),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,

          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),

          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });

            final entry = _diaryMap[_normalize(selectedDay)];

            widget.onDaySelected(entry);
          },

          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },

          eventLoader: (day) {
            final normalized = _normalize(day);
            return _diaryMap.containsKey(normalized) ? [normalized] : [];
          },

          calendarStyle: CalendarStyle(
            isTodayHighlighted: true,           
            todayDecoration: BoxDecoration(shape: BoxShape.circle, color: scheme.primary),
            selectedDecoration: BoxDecoration(shape: BoxShape.circle, color: scheme.primary),
            selectedTextStyle: TextStyle(
              color: scheme.surface,
              fontWeight: FontWeight.bold,
            ),
          ),

          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, day, events) {
              if (events.isNotEmpty) {
                return Positioned(
                  bottom: 4,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(color: scheme.tertiary ,shape: BoxShape.circle),
                  ),
                );
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}
