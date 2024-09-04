// lib/features/calculator/bloc/save_result_cubit/save_result_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:image_calculator/features/calculator/data/models/calculation_result.dart';
import 'package:image_calculator/features/calculator/presentations/screens/success_screen.dart';
import 'package:image_calculator/services/database_storage_service.dart';
import 'package:image_calculator/services/file_storage_service.dart';
import 'package:meta/meta.dart';

part 'save_result_state.dart';

class SaveResultCubit extends Cubit<SaveResultState> {
  final FileStorageService fileStorageService = FileStorageService();
  final DatabaseStorageService databaseStorageService = DatabaseStorageService();

  SaveResultCubit() : super(SaveResultInitial());

  Future<void> saveResult(CalculationResult result, StorageType type) async {
    emit(SaveResultLoading());

    try {
      if (type == StorageType.file) {
        await fileStorageService.storeToFileStorage(result);
        emit(SaveResultSuccess('Saved to File'));
      } else if (type == StorageType.database) {
        await databaseStorageService.storeToDatabaseStorage(result);
        emit(SaveResultSuccess('Saved to Database'));
      }
    } catch (e) {
      emit(SaveResultFailure('Failed to save result: $e'));
    }
  }
}
