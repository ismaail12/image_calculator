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
    try {
      CalculationResult? calculationResult;
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
        print(
            'Hasil dari ${calculationResult.input} adalah ${calculationResult.result}');
        emit(CalculateImageSuccess(
            'Operation completed successfully.', calculationResult));
      } else {
        emit(CalculateImageFailure('Failed to calculate image.'));
      }
    } catch (e) {
      emit(CalculateImageFailure(e.toString()));
    }
  }

  Future<CalculationResult?> _handleAppRedCameraRoll() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      print('Tidak ada gambar yang dipilih.');
      return null;
    }
    return await imageRepository.processImage(File(image.path));
  }

  Future<CalculationResult?> _handleAppRedBuiltInCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) {
      print('Tidak ada gambar yang diambil.');
      return null;
    }
    return await imageRepository.processImage(File(image.path));
  }

  Future<CalculationResult?> _handleAppGreenFilesystem() async {
    final FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null || result.files.single.path == null) {
      print('Tidak ada file yang dipilih.');
      return null;
    }
    return await imageRepository.processImage(File(result.files.single.path!));
  }

  Future<CalculationResult?> _handleAppGreenCameraRoll() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      print('Tidak ada gambar yang dipilih.');
      return null;
    }
    return await imageRepository.processImage(File(image.path));
  }
}
