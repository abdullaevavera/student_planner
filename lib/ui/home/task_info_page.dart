import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../data/models/task_with_tag.dart';
import '../../data/sources/local/drift/db.dart';
import 'widgets/colored_mark.dart';
import 'widgets/task_completion_checkbox.dart';

class TaskInfoPage extends StatefulWidget {
  final TaskWithTag taskWithTag;

  const TaskInfoPage({
    super.key,
    required this.taskWithTag,
  });

  @override
  State<TaskInfoPage> createState() => _TaskInfoPageState();
}

class _TaskInfoPageState extends State<TaskInfoPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Task Info'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Consumer<AppDatabase>(
              builder: (context, value, child) => StreamBuilder<TaskWithTag?>(
                stream: value.taskDao.watchTask(widget.taskWithTag.task),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox();

                  final taskWithTag = snapshot.data!;

                  final task = taskWithTag.task;
                  final tag = taskWithTag.tag;
                  final title = task.title;
                  final description = task.description;
                  final deadline = DateFormat.yMd().add_jm().format(task.deadline);
                  final place = task.place;
                  final tagName = tag?.name;
                  final tagColor = tag?.color != null ? Color(tag!.color) : null;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Title:',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const Gap(8),
                          Expanded(
                            child: Text(
                              title,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                        ],
                      ),
                      if (description != null) ...[
                        const Gap(8),
                        Row(
                          children: [
                            Text(
                              'Description:',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const Gap(8),
                            Text(
                              description,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ],
                      const Gap(8),
                      Row(
                        children: [
                          Text(
                            'Deadline:',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const Gap(8),
                          Text(
                            deadline,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                      if (place != null) ...[
                        const Gap(8),
                        Row(
                          children: [
                            Text(
                              'Place:',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const Gap(8),
                            Text(
                              place,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ],
                      const Gap(8),
                      Row(
                        children: [
                          Text(
                            'Completed:',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          TaskCompletionCheckbox(task: task),
                        ],
                      ),
                      if (tagName != null && tagColor != null) ...[
                        const Gap(8),
                        Row(
                          children: [
                            ColoredMark(color: tagColor),
                            const Gap(8),
                            Text(
                              tagName,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ],
                      const Gap(8),
                      ElevatedButton(
                        onPressed: () async {
                          await context.read<AppDatabase>().taskDao.deleteTask(task);

                          if (!mounted) return;

                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                        child: Text(
                          'Remove task',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );
}
