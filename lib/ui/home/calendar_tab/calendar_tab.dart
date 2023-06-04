import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../data/models/task_with_tag.dart';
import '../../../data/sources/local/drift/db.dart';
import '../widgets/tasks_list.dart';
import '../widgets/tasks_placeholder.dart';

class CalendarTab extends StatefulWidget {
  const CalendarTab({super.key});

  @override
  State<CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends State<CalendarTab> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          TableCalendar<TaskWithTag>(
            firstDay: DateTime.now().subtract(const Duration(days: 180)),
            lastDay: DateTime.now().add(const Duration(days: 180)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) => setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            }),
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) => setState(() => _calendarFormat = format),
          ),
          Expanded(
            child: Consumer<AppDatabase>(
              builder: (context, value, child) => StreamBuilder<List<TaskWithTag>>(
                stream: value.taskDao.watchTasks(
                  from: _selectedDay,
                  to: _selectedDay.add(const Duration(days: 1)),
                ),
                builder: (context, snapshot) {
                  final tasks = snapshot.data ?? [];

                  if (tasks.isEmpty) return const TasksPlaceholder(text: 'No tasks for today');

                  return TasksList(tasks: tasks);
                },
              ),
            ),
          ),
        ],
      );
}
