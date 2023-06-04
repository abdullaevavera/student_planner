import 'package:flutter/material.dart';

import 'home/main_page.dart';
import 'injection.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) => const Injection(
        child: MaterialApp(
          title: 'StudentPlanner',
          home: MainPage(),
          debugShowCheckedModeBanner: false,
        ),
      );
}
