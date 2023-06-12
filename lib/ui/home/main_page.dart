import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../logic/tab_cubit.dart';
import 'add_task_page.dart';
import 'calendar_tab/calendar_tab.dart';
import 'today_tab/today_tab.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) => Provider(
        create: (context) => TabCubit(),
        dispose: (context, value) => value.close(),
        builder: (context, child) => Scaffold(
          extendBody: true,
          appBar: AppBar(
            title: BlocBuilder<TabCubit, int>(
              bloc: context.watch<TabCubit>(),
              builder: (context, state) => Text(state == 0 ? 'Today' : 'Calendar'),
            ),
          ),
          body: BlocBuilder<TabCubit, int>(
            bloc: context.watch<TabCubit>(),
            builder: (context, state) => IndexedStack(
              index: state,
              children: const [
                TodayTab(),
                CalendarTab(),
              ],
            ),
          ),
          bottomNavigationBar: const BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _Button(
                  index: 0,
                  icon: Icons.today,
                ),
                _Button(
                  index: 1,
                  icon: Icons.calendar_month,
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const AddTaskPage(),
              ),
            ),
            child: const Icon(
              Icons.add,
              size: 32,
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        ),
      );
}

class _Button extends StatelessWidget {
  final int index;
  final IconData icon;

  const _Button({
    required this.index,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) => IconButton(
        icon: Icon(
          icon,
        ),
        iconSize: 32,
        onPressed: () => context.read<TabCubit>().onItemTapped(index),
      );
}
