import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_calculator/features/calculator/blocs/get_calculation_result_cubit/get_calculation_result_cubit.dart';
import 'package:image_calculator/features/calculator/presentations/screens/detail_calculation_result.dart';
import 'package:image_calculator/features/calculator/presentations/screens/success_screen.dart';
import 'package:image_calculator/features/calculator/presentations/widgets/custom_bottom_sheet.dart';

class FileStorageWidget extends StatelessWidget {
  const FileStorageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetCalculationResultCubit()..fetchResults(StorageType.file),
      child: BlocBuilder<GetCalculationResultCubit, GetCalculationResultState>(
        builder: (context, state) {
          if (state is GetCalculationResultLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetCalculationResultSuccess) {
            return RefreshIndicator(
              onRefresh: () async {
                // Trigger a new fetch operation to refresh the data
                context.read<GetCalculationResultCubit>().fetchResults(StorageType.file);
              },
              child: ListView.builder(
                itemCount: state.results.length,
                itemBuilder: (context, index) {
                  final calculation = state.results[index];
                  return ListTile(
                    onTap: () {
                      showCustomBottomSheet(
                        context,
                        child: DetailCalculationResult(calculation: calculation),
                      );
                    },
                    title: Text('Input: ${calculation.input}'),
                    subtitle: Text('Result: ${calculation.result}'),
                  );
                },
              ),
            );
          } else if (state is GetCalculationResultFailure) {
            return Center(child: Text(state.error));
          } else {
            return const Center(child: Text('No data found.'));
          }
        },
      ),
    );
  }
}
