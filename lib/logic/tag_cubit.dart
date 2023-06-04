import 'package:bloc/bloc.dart';

import '../data/sources/local/drift/db.dart';

class TagCubit extends Cubit<Tag?> {
  TagCubit() : super(null);

  void onTagUpdated(Tag? selectedTag) => emit(selectedTag);
}
