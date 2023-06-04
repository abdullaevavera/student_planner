import 'package:freezed_annotation/freezed_annotation.dart';

import '../sources/local/drift/db.dart';

part 'task_with_tag.freezed.dart';

@freezed
class TaskWithTag with _$TaskWithTag {
  const factory TaskWithTag({
    required Task task,
    Tag? tag,
  }) = _TaskWithTag;
}
