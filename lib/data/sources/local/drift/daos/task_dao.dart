import 'package:drift/drift.dart';

import '../../../../models/task_with_tag.dart';
import '../db.dart';
import '../tables/tags.dart';
import '../tables/tasks.dart';

part 'task_dao.g.dart';

@DriftAccessor(tables: [Tasks, Tags])
class TaskDao extends DatabaseAccessor<AppDatabase> with _$TaskDaoMixin {
  TaskDao(super.db);

  Stream<List<TaskWithTag>> watchTasks({
    DateTime? from,
    DateTime? to,
  }) {
    assert((from != null) == (to != null));

    final selected = select(tasks);

    if (from != null && to != null) selected.where((t) => t.deadline.isBetweenValues(from, to));

    selected.orderBy(
      [
        (t) => OrderingTerm(expression: t.deadline),
        (t) => OrderingTerm(expression: t.title),
      ],
    );

    return selected
        .join(
          [
            leftOuterJoin(tags, tags.name.equalsExp(tasks.tagName)),
          ],
        )
        .watch()
        .map((e) => e.map((e) => TaskWithTag(task: e.readTable(tasks), tag: e.readTableOrNull(tags))).toList());
  }

  Stream<TaskWithTag?> watchTask(Task task) => (select(tasks)..where((t) => t.id.equals(task.id)))
      .join(
        [
          leftOuterJoin(tags, tags.name.equalsExp(tasks.tagName)),
        ],
      )
      .watchSingleOrNull()
      .map((e) => e != null ? TaskWithTag(task: e.readTable(tasks), tag: e.readTableOrNull(tags)) : null);

  Future<void> insertTask(Insertable<Task> task) => into(tasks).insert(task);

  Future<void> updateTask(Insertable<Task> task) => update(tasks).replace(task);

  Future<void> deleteTask(Insertable<Task> task) => delete(tasks).delete(task);
}
