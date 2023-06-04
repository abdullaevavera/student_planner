import 'package:bloc/bloc.dart';

class DateTimeCubit extends Cubit<DateTime> {
  DateTimeCubit() : super(DateTime.now());

  void onDateTimeSelected(DateTime selectedDateTime) => emit(selectedDateTime);
}
