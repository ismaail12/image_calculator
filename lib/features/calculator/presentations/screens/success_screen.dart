// lib/features/calculator/presentations/screens/success_screen.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_calculator/features/calculator/blocs/get_calculation_result_cubit/get_calculation_result_cubit.dart';
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Image.file(
                File(result.path),
                height: 400,
              )),
              const SizedBox(height: 16),
              Text('Input: ${result.input}',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text('Result: ${result.result}',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              Column(
                children: [
                  BlocConsumer<SaveResultCubit, SaveResultState>(
                    listener: (context, state) {
                      if (state is SaveResultLoading) {
                        EasyLoading.show(status: 'Processing');
                      }

                      if (state is SaveResultSuccess) {
                        EasyLoading.dismiss();

                      } else if (state is SaveResultFailure) {
                        EasyLoading.dismiss();
                        EasyLoading.showInfo(state.error);
                      }
                    },
                    builder: (context, state) {
                      return Column(
                        children: [
                          CustomButton(
                            isFullWidth: true,
                            onPressed: () =>
                                _saveResult(context, StorageType.file),
                            text: 'Save to File',
                          ),
                          const SizedBox(width: 16),
                          CustomButton(
                            color: Colors.amber,
                            isFullWidth: true,
                            onPressed: () =>
                                _saveResult(context, StorageType.database),
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
      ),
    );
  }

  Future<void> _saveResult(BuildContext context, StorageType type) async {
    final saveResultCubit = context.read<SaveResultCubit>();
    await saveResultCubit.saveResult(result, type);
    Future.delayed(
      Duration.zero,
      () {
        context.read<GetCalculationResultCubit>().fetchResults(type);
        Navigator.pop(context);
      },
    );
  }
}

enum StorageType { file, database }
