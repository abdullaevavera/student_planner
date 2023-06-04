import 'dart:ui';

import 'package:bloc/bloc.dart';

class ColorCubit extends Cubit<Color> {
  ColorCubit() : super(const Color(0xFF000000));

  void onColorSelected(Color selectedColor) => emit(selectedColor);
}
