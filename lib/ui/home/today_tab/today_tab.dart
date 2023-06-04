import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/task_with_tag.dart';
import '../../../data/sources/local/drift/db.dart';
import '../widgets/tasks_list.dart';
import '../widgets/tasks_placeholder.dart';

class TodayTab extends StatelessWidget {
  const TodayTab({super.key});

  @override
  Widget build(BuildContext context) => Consumer<AppDatabase>(
        builder: (context, value, child) => StreamBuilder<List<TaskWithTag>>(
          stream: value.taskDao.watchTasks(
            from: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            ),
            to: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day + 1,
            ),
          ),
          builder: (context, snapshot) {
            final tasks = snapshot.data ?? [];

            if (tasks.isEmpty) return const TasksPlaceholder(text: 'No tasks for today');

            return TasksList(tasks: tasks);
          },
        ),
      );
}
