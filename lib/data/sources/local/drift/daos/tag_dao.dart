import 'package:drift/drift.dart';

import '../db.dart';
import '../tables/tags.dart';

part 'tag_dao.g.dart';

@DriftAccessor(tables: [Tags])
class TagDao extends DatabaseAccessor<AppDatabase> with _$TagDaoMixin {
  TagDao(super.db);

  Stream<List<Tag>> watchTags() => select(tags).watch();

  Future<void> insertTag(Insertable<Tag> tag) => into(tags).insert(tag);

  Future<void> deleteTag(Insertable<Tag> tag) => delete(tags).delete(tag);
}
