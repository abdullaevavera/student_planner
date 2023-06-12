import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/sources/local/drift/db.dart';
import '../data/sources/local/notifications/notifications_service.dart';

class Injection extends StatefulWidget {
  final Widget child;

  const Injection({
    super.key,
    required this.child,
  });

  @override
  State<Injection> createState() => _InjectionState();
}

class _InjectionState extends State<Injection> {
  final future = NotificationsService.create();

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            return Provider.value(
              value: snapshot.data!,
              child: Provider(
                create: (context) => AppDatabase(),
                dispose: (context, value) => value.close(),
                builder: (context, child) => widget.child,
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      );
}
