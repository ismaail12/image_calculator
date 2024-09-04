import 'package:bloc/bloc.dart';
import 'package:image_calculator/features/calculator/data/models/calculation_result.dart';
import 'package:image_calculator/features/calculator/data/repositories/image_repository.dart';
import 'package:image_calculator/features/calculator/presentations/screens/success_screen.dart';
import 'package:meta/meta.dart';

part 'get_calculation_result_state.dart';

class GetCalculationResultCubit extends Cubit<GetCalculationResultState> {

  final repository = ImageRepository();

  GetCalculationResultCubit()
      : super(GetCalculationResultInitial());

Future<void> fetchResults(StorageType storageType) async {
    emit(GetCalculationResultLoading());


    try {
      final List<CalculationResult> fromFiles = await repository.readFromFileStorage();
      final List<CalculationResult> fromDatabase = await repository.readFromDatabaseStorage();

      if (fromFiles.isNotEmpty || fromDatabase.isNotEmpty)   {
        emit(GetCalculationResultSuccess(
          fromFiles, fromDatabase
        ));
      } else {
        emit(GetCalculationResultFailure('No results found.'));
      }
    } catch (e) {
      emit(GetCalculationResultFailure('Failed to fetch results: $e'));
    }
  }
}