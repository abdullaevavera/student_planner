import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../data/sources/local/drift/db.dart';
import '../../logic/color_cubit.dart';
import '../utils.dart';
import 'widgets/colored_mark.dart';

class AddTagPage extends StatefulWidget {
  const AddTagPage({super.key});

  @override
  State<AddTagPage> createState() => _AddTagPageState();
}

class _AddTagPageState extends State<AddTagPage> {
  final nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Provider<ColorCubit>(
        create: (context) => ColorCubit(),
        dispose: (context, value) => value.close(),
        builder: (context, child) => GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Add new tag'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Name:',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const Gap(8),
                        Expanded(
                          child: TextField(
                            controller: nameController,
                          ),
                        ),
                      ],
                    ),
                    const Gap(8),
                    Row(
                      children: [
                        Text(
                          'Color:',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const Gap(8),
                        BlocBuilder<ColorCubit, Color>(
                          builder: (context, state) => IconButton(
                            onPressed: () async => showDialog<void>(
                              context: context,
                              builder: (_) => AlertDialog(
                                contentPadding: const EdgeInsets.all(6.0),
                                title: const Text('Select color'),
                                content: BlockPicker(
                                  pickerColor: state,
                                  availableColors: availableColors,
                                  onColorChanged: (value) => context.read<ColorCubit>().onColorSelected(value),
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () => Navigator.of(context).pop(),
                                  ),
                                ],
                              ),
                            ),
                            icon: ColoredMark(
                              color: state,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(8),
                    ElevatedButton(
                      onPressed: () async {
                        final name = nameController.text;
                        final color = context.read<ColorCubit>().state.value;

                        try {
                          await context.read<AppDatabase>().tagDao.insertTag(
                                TagsCompanion.insert(
                                  name: name,
                                  color: color,
                                ),
                              );
                        } catch (_) {
                          ScaffoldMessenger.of(context)
                            ..clearSnackBars()
                            ..showSnackBar(const SnackBar(content: Text('Incorrect data!')));

                          return;
                        }

                        if (!mounted) return;

                        Navigator.of(context).pop();
                      },
                      child: const Text('Add tag'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
