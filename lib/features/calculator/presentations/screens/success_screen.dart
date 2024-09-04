// lib/features/calculator/presentations/screens/success_screen.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_calculator/features/calculator/blocs/save_result_cubit/save_result_cubit.dart';
import 'package:image_calculator/features/calculator/data/models/calculation_result.dart';
import 'package:image_calculator/features/calculator/presentations/widgets/custom_button.dart';

class SuccessScreen extends StatelessWidget {
  final CalculationResult result;

  const SuccessScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculation Result'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.file(File(result.path)),
            SizedBox(height: 16),
            Text('Input: ${result.input}', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 8),
            Text('Result: ${result.result}', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 16),
            Column(
              children: [
                BlocConsumer<SaveResultCubit, SaveResultState>(
                  listener: (context, state) {

                    if (state is SaveResultLoading) {
                      EasyLoading.show(status: 'Processing');
                    }

                    if (state is SaveResultSuccess) {
                      EasyLoading.dismiss();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
                    } else if (state is SaveResultFailure) {
                      EasyLoading.dismiss();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error)));
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      children: [
                        CustomButton(
                          isFullWidth: true,
                          onPressed: () => _saveResult(context, StorageType.file),
                          text: 'Save to File',
                        ),
                        SizedBox(width: 16),
                        CustomButton(
                          color: Colors.amber,
                          isFullWidth: true,
                          onPressed: () => _saveResult(context, StorageType.database),
                          text: 'Save to Database',
                        ),

                      ],
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveResult(BuildContext context, StorageType type) async {
    final saveResultCubit = context.read<SaveResultCubit>();
    await saveResultCubit.saveResult(result, type);
    Future.delayed(Duration.zero, () {
      Navigator.pop(context);
    },);
  }
}

enum StorageType { file, database }
