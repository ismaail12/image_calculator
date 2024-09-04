import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_calculator/features/calculator/data/models/calculation_result.dart';
import 'package:image_calculator/features/calculator/data/repositories/image_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_calculator/bootstrap.dart';
import 'package:meta/meta.dart';
import 'dart:io';

part 'calculate_image_state.dart';

class CalculateImageCubit extends Cubit<CalculateImageState> {
  final Flavor flavor;
  final imageRepository = ImageRepository();

  CalculateImageCubit(this.flavor) : super(CalculateImageInitial());

  Future<void> calculateImage() async {
    emit(CalculateImageLoading());
    CalculationResult? calculationResult;

    try {
      switch (flavor) {
        case Flavor.appRedCameraRoll:
          calculationResult = await _handleAppRedCameraRoll();
          break;
        case Flavor.appRedBuiltInCamera:
          calculationResult = await _handleAppRedBuiltInCamera();
          break;
        case Flavor.appGreenFilesystem:
          calculationResult = await _handleAppGreenFilesystem();
          break;
        case Flavor.appGreenCameraRoll:
          calculationResult = await _handleAppGreenCameraRoll();
          break;
      }

      if (calculationResult != null) {
        emit(CalculateImageSuccess(
            'Operation completed successfully.', calculationResult));
      } 
    } catch (e) {
      emit(CalculateImageFailure('An error occurred: ${e.toString()}'));
    }
  }

  Future<CalculationResult?> _handleAppRedCameraRoll() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) {
        emit(CalculateImageFailure('No image selected.'));
        return null;
      }
      return await imageRepository.processImage(File(image.path));
    } catch (e) {
      emit(CalculateImageFailure('Failed to process image: ${e.toString()}'));
      return null;
    }
  }

  Future<CalculationResult?> _handleAppRedBuiltInCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image == null) {
        emit(CalculateImageFailure('No image captured.'));
        return null;
      }
      return await imageRepository.processImage(File(image.path));
    } catch (e) {
      emit(CalculateImageFailure('Failed to process image: ${e.toString()}'));
      return null;
    }
  }

  Future<CalculationResult?> _handleAppGreenFilesystem() async {
    try {
      final FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (result == null || result.files.single.path == null) {
        emit(CalculateImageFailure('No file selected.'));
        return null;
      }
      return await imageRepository.processImage(File(result.files.single.path!));
    } catch (e) {
      emit(CalculateImageFailure('Failed to process file: ${e.toString()}'));
      return null;
    }
  }

  Future<CalculationResult?> _handleAppGreenCameraRoll() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) {
        emit(CalculateImageFailure('No image selected.'));
        return null;
      }
      return await imageRepository.processImage(File(image.path));
    } catch (e) {
      emit(CalculateImageFailure('Failed to process image: ${e.toString()}'));
      return null;
    }
  }
}
