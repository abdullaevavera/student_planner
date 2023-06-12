import 'package:flutter/material.dart';

import 'home/main_page.dart';
import 'injection.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) => Injection(
        child: MaterialApp(
          title: 'StudentPlanner',
          home: const MainPage(),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
          ),
          darkTheme: ThemeData.dark(
            useMaterial3: true,
          ),
        ),
      );
}
