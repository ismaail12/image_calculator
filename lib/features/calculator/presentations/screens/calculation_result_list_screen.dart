import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_calculator/features/calculator/blocs/get_calculation_result_cubit/get_calculation_result_cubit.dart';
import 'package:image_calculator/features/calculator/presentations/screens/detail_calculation_result_screen.dart';
import 'package:image_calculator/features/calculator/presentations/screens/success_screen.dart';
import 'package:image_calculator/features/calculator/presentations/widgets/custom_bottom_sheet.dart';


class CalculationResultListScreen extends StatelessWidget {
  final StorageType storageType;

  const CalculationResultListScreen({super.key, required this.storageType});

  @override
  Widget build(BuildContext context) {
    context.read<GetCalculationResultCubit>().fetchResults(storageType);

    return BlocBuilder<GetCalculationResultCubit, GetCalculationResultState>(
      builder: (context, state) {
        if (state is GetCalculationResultLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GetCalculationResultSuccess) {
          final results = storageType == StorageType.file
              ? state.fromFiles
              : state.fromDatabase;

          if (results.isEmpty) {
            return const Center(child: Text('No data found'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              context
                  .read<GetCalculationResultCubit>()
                  .fetchResults(storageType);
            },
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final calculation = results[index];
                return ListTile(
                  onTap: () {
                    showCustomBottomSheet(
                      context,
                      child: DetailCalculationResultScreen(
                          calculation: calculation),
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
    );
  }
}
