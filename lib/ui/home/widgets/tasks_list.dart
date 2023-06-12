import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../../../data/models/task_with_tag.dart';
import '../task_info_page.dart';
import 'colored_mark.dart';
import 'task_completion_checkbox.dart';

class TasksList extends StatelessWidget {
  final List<TaskWithTag> tasks;

  const TasksList({
    super.key,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) => ListView.builder(
        padding: const EdgeInsets.only(bottom: 120),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final taskWithTag = tasks[index];
          final task = taskWithTag.task;
          final tag = taskWithTag.tag;
          final title = task.title;
          final description = task.description;
          final deadline = DateFormat.jm().format(task.deadline);
          final place = task.place;
          final tagName = tag?.name;
          final tagColor = tag?.color != null ? Color(tag!.color) : null;

          Color? textColor;

          final isOver = task.deadline.isBefore(DateTime.now());

          if (isOver) {
            textColor = Theme.of(context).disabledColor;
          }

          return InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => TaskInfoPage(taskWithTag: taskWithTag),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Row(
                children: [
                  Text(
                    deadline,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: textColor),
                  ),
                  const Gap(8),
                  if (tagColor != null) ...[
                    ColoredMark(color: tagColor),
                    const Gap(8),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (tagName != null)
                          Text(
                            tagName,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: textColor),
                          ),
                        Text(
                          title,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: textColor),
                        ),
                        if (description != null)
                          Text(
                            description,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: textColor),
                          ),
                        if (place != null)
                          Text(
                            place,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: textColor),
                          ),
                      ],
                    ),
                  ),
                  const Gap(8),
                  TaskCompletionCheckbox(task: task),
                ],
              ),
            ),
          );
        },
      );
}
