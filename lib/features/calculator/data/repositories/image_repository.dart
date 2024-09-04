// Import the ImageProcessingService

import 'dart:io';

import 'package:image_calculator/features/calculator/data/models/calculation_result.dart';
import 'package:image_calculator/services/database_storage_service.dart';
import 'package:image_calculator/services/file_storage_service.dart';
import 'package:image_calculator/services/image_processing_service.dart';

class ImageRepository {

  final  imageProcessingService = ImageProcessingService();
  final  fileStorageService = FileStorageService();
  final  databaseStorageService = DatabaseStorageService();


  Future<CalculationResult?> processImage(File imageFile) {
    return imageProcessingService.processImage(imageFile);
  }

Future<void> storeToFileStorage(CalculationResult calculation) async {
    await fileStorageService.storeToFileStorage(calculation);
  }

  Future<void> storeToDatabaseStorage(CalculationResult calculation) async {
    await databaseStorageService.storeToDatabaseStorage(calculation);
  }


  Future<List<CalculationResult>> readFromDatabaseStorage() async {
    return await databaseStorageService.readFromDatabaseStorage();
  }

  Future<List<CalculationResult>> listStorage() async {
    final fileResults = await fileStorageService.listStorageFiles();
    final dbResults = await databaseStorageService.listTables();
    return [...fileResults, ...dbResults];
  }
}












