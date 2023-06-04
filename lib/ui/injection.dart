import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/sources/local/drift/db.dart';

class Injection extends StatelessWidget {
  final Widget child;

  const Injection({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => Provider(
        create: (context) => AppDatabase(),
        dispose: (context, value) => value.close(),
        builder: (context, child) => this.child,
      );
}
