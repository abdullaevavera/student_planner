import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/sources/local/drift/db.dart';

class TaskCompletionCheckbox extends StatelessWidget {
  final Task task;

  const TaskCompletionCheckbox({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) => Checkbox(
        value: task.completed,
        onChanged: (value) {
          if (value != null) {
            context
                .read<AppDatabase>()
                .taskDao
                .updateTask(task.toCompanion(true).copyWith(completed: drift.Value(value)));
          }
        },
      );
}
