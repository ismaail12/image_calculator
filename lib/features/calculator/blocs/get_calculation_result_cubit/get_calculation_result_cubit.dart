import 'package:bloc/bloc.dart';
import 'package:image_calculator/features/calculator/data/models/calculation_result.dart';
import 'package:image_calculator/features/calculator/presentations/screens/success_screen.dart';
import 'package:image_calculator/services/database_storage_service.dart';
import 'package:image_calculator/services/file_storage_service.dart';
import 'package:meta/meta.dart';

part 'get_calculation_result_state.dart';

class GetCalculationResultCubit extends Cubit<GetCalculationResultState> {
  final _databaseStorageService = DatabaseStorageService();
  final _fileStorageService = FileStorageService();

  GetCalculationResultCubit()
      : super(GetCalculationResultInitial());

Future<void> fetchResults(StorageType storageType) async {
    emit(GetCalculationResultLoading());

    try {
      List<CalculationResult> results = [];
      
      if (storageType == StorageType.file) {
        results = await _fileStorageService.listStorageFiles();
      }

      if (results.isNotEmpty) {
        emit(GetCalculationResultSuccess(results));
      } else {
        emit(GetCalculationResultFailure('No results found.'));
      }
    } catch (e) {
      emit(GetCalculationResultFailure('Failed to fetch results: $e'));
    }
  }
}