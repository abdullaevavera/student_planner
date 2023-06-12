import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../data/sources/local/drift/db.dart';
import 'add_tag_page.dart';
import 'widgets/colored_mark.dart';
import 'widgets/tasks_placeholder.dart';

class TagsPage extends StatelessWidget {
  const TagsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Tags'),
          actions: [
            IconButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const AddTagPage(),
                ),
              ),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: Consumer<AppDatabase>(
          builder: (context, value, child) => StreamBuilder<List<Tag>>(
            stream: value.tagDao.watchTags(),
            builder: (context, snapshot) {
              final tags = snapshot.data ?? [];

              if (tags.isEmpty) return const TasksPlaceholder(text: 'No tags');

              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: tags.length,
                itemBuilder: (context, index) {
                  final tag = tags[index];
                  final tagName = tag.name;
                  final tagColor = Color(tag.color);

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        ColoredMark(color: tagColor),
                        const Gap(8),
                        Expanded(
                          child: Text(
                            tagName,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        const Gap(8),
                        IconButton(
                          onPressed: () => context.read<AppDatabase>().tagDao.deleteTag(tag),
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      );
}
