import 'dart:io';

import 'package:image_calculator/features/calculator/data/models/calculation_result.dart';
import 'package:image_calculator/services/database_storage_service.dart';
import 'package:image_calculator/services/file_storage_service.dart';
import 'package:image_calculator/services/image_processing_service.dart';

class ImageRepository {
  final imageProcessingService = ImageProcessingService();
  final fileStorageService = FileStorageService();
  final databaseStorageService = DatabaseStorageService();

  Future<CalculationResult?> processImage(File imageFile) async {
    try {
      return await imageProcessingService.processImage(imageFile);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> storeToFileStorage(CalculationResult calculation) async {
    try {
      await fileStorageService.storeToFileStorage(calculation);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> storeToDatabaseStorage(CalculationResult calculation) async {
    try {
      await databaseStorageService.storeToDatabaseStorage(calculation);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CalculationResult>> readFromDatabaseStorage() async {
    try {
      return await databaseStorageService.readFromDatabaseStorage();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CalculationResult>> readFromFileStorage() async {
    try {
      return await fileStorageService.listStorageFiles();
    } catch (e) {
      rethrow;
    }
  }
}
