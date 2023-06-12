import 'package:flutter/material.dart';

class TasksPlaceholder extends StatelessWidget {
  final String text;

  const TasksPlaceholder({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) => Center(
        child: Text(
          text,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      );
}
