import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'daos/tag_dao.dart';
import 'daos/task_dao.dart';
import 'tables/tags.dart';
import 'tables/tasks.dart';

part 'db.g.dart';

@DriftDatabase(tables: [Tasks, Tags], daos: [TaskDao, TagDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) => customStatement('PRAGMA foreign_keys = ON'),
      );

  static LazyDatabase _openConnection() => LazyDatabase(() async {
        final dbFolder = await getApplicationSupportDirectory();
        final file = File(path.join(dbFolder.path, 'db.sqlite'));
        return NativeDatabase(file);
      });
}
