import 'dart:ui';

import 'package:bloc/bloc.dart';

import '../ui/utils.dart';

class ColorCubit extends Cubit<Color> {
  ColorCubit() : super(availableColors.first);

  void onColorSelected(Color selectedColor) => emit(selectedColor);
}
