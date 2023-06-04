import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'ui/application.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const Application());
}
