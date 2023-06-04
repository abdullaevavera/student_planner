import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../data/sources/local/drift/db.dart';
import '../../logic/date_time_cubit.dart';
import '../../logic/tag_cubit.dart';
import 'tags_page.dart';
import 'widgets/colored_mark.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final placeController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    placeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider<DateTimeCubit>(
            create: (context) => DateTimeCubit(),
            dispose: (context, value) => value.close(),
          ),
          Provider<TagCubit>(
            create: (context) => TagCubit(),
            dispose: (context, value) => value.close(),
          ),
        ],
        builder: (context, child) => GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Add new task'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Consumer<AppDatabase>(
                  builder: (context, value, child) => StreamBuilder<List<Tag>>(
                    stream: value.tagDao.watchTags(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox();

                      final tags = snapshot.data!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Title:',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              const Gap(8),
                              Expanded(
                                child: TextField(
                                  controller: titleController,
                                  textInputAction: TextInputAction.next,
                                ),
                              ),
                            ],
                          ),
                          const Gap(8),
                          Row(
                            children: [
                              Text(
                                'Description:',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              const Gap(8),
                              Expanded(
                                child: TextField(
                                  controller: descriptionController,
                                ),
                              ),
                            ],
                          ),
                          const Gap(8),
                          Row(
                            children: [
                              Text(
                                'Deadline:',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              const Gap(8),
                              Expanded(
                                child: BlocBuilder<DateTimeCubit, DateTime>(
                                  builder: (context, state) {
                                    final deadline = DateFormat.yMd().add_jm().format(state);

                                    return Text(deadline);
                                  },
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  final dateTime = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                                    lastDate: DateTime.now().add(const Duration(days: 365)),
                                  );

                                  if (dateTime == null) return;

                                  final timeOfDay = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );

                                  if (timeOfDay == null) return;

                                  final deadline = dateTime.add(
                                    Duration(
                                      hours: timeOfDay.hour,
                                      minutes: timeOfDay.minute,
                                    ),
                                  );

                                  if (!mounted) return;

                                  context.read<DateTimeCubit>().onDateTimeSelected(deadline);
                                },
                                icon: const Icon(Icons.date_range),
                              ),
                            ],
                          ),
                          const Gap(8),
                          Row(
                            children: [
                              Text(
                                'Place:',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              const Gap(8),
                              Expanded(
                                child: TextField(
                                  controller: placeController,
                                ),
                              ),
                            ],
                          ),
                          const Gap(8),
                          Row(
                            children: [
                              Text(
                                'Tag:',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              const Gap(8),
                              Expanded(
                                child: BlocBuilder<TagCubit, Tag?>(
                                  builder: (context, state) => DropdownButton(
                                    isExpanded: true,
                                    value: state,
                                    onChanged: (value) => context.read<TagCubit>().onTagUpdated(value),
                                    items: [
                                      DropdownMenuItem<Tag?>(
                                        child: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Text(
                                            'None',
                                            style: Theme.of(context).textTheme.bodyText1,
                                          ),
                                        ),
                                      ),
                                      ...tags.map(
                                        (e) => DropdownMenuItem(
                                          value: e,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: Row(
                                              children: [
                                                ColoredMark(color: Color(e.color)),
                                                const Gap(8),
                                                Text(
                                                  e.name,
                                                  style: Theme.of(context).textTheme.bodyText1,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ].toList(),
                                  ),
                                ),
                              ),
                              const Gap(8),
                              IconButton(
                                onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (context) => const TagsPage(),
                                  ),
                                ),
                                icon: const Icon(Icons.edit),
                              ),
                            ],
                          ),
                          const Gap(8),
                          ElevatedButton(
                            onPressed: () async {
                              final tagName = context.read<TagCubit>().state?.name;
                              final title = titleController.text;
                              final description = descriptionController.text;
                              final deadline = context.read<DateTimeCubit>().state;
                              final place = placeController.text;

                              await context.read<AppDatabase>().taskDao.insertTask(
                                    TasksCompanion.insert(
                                      tagName: drift.Value(tagName),
                                      createdAt: DateTime.now(),
                                      title: title,
                                      description: drift.Value(description),
                                      deadline: deadline,
                                      place: drift.Value(place),
                                    ),
                                  );

                              if (!mounted) return;

                              Navigator.of(context).pop();
                            },
                            child: const Text('Add task'),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
