import 'package:drift/drift.dart';

class Tasks extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get tagName => text().nullable().customConstraint('NULL REFERENCES tags(name) ON DELETE SET NULL')();

  DateTimeColumn get createdAt => dateTime()();

  TextColumn get title => text().withLength(min: 1, max: 50)();

  TextColumn get description => text().nullable().withLength(min: 1, max: 200)();

  DateTimeColumn get deadline => dateTime()();

  TextColumn get place => text().nullable()();

  BoolColumn get completed => boolean().withDefault(const Constant(false))();
}
