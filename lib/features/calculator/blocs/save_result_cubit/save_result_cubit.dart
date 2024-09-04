// lib/features/calculator/bloc/save_result_cubit/save_result_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:image_calculator/features/calculator/data/models/calculation_result.dart';
import 'package:image_calculator/features/calculator/data/repositories/image_repository.dart';
import 'package:image_calculator/features/calculator/presentations/screens/success_screen.dart';
import 'package:meta/meta.dart';

part 'save_result_state.dart';

class SaveResultCubit extends Cubit<SaveResultState> {
  final imageRepository = ImageRepository();

  SaveResultCubit() : super(SaveResultInitial());

  Future<void> saveResult(CalculationResult result, StorageType type) async {
    emit(SaveResultLoading());

    try {
      if (type == StorageType.file) {
        await imageRepository.storeToFileStorage(result);
        emit(SaveResultSuccess('Saved to File'));
      } else if (type == StorageType.database) {
        await imageRepository.storeToDatabaseStorage(result);
        emit(SaveResultSuccess('Saved to Database'));
      }
    } catch (e) {
      emit(SaveResultFailure('Failed to save result: $e'));
    }
  }
}
