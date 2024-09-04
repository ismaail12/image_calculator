import 'dart:io';
import 'dart:convert';
import 'package:image_calculator/features/calculator/data/models/calculation_result.dart';
import 'package:path_provider/path_provider.dart';

class FileStorageService {
  Future<void> storeToFileStorage(CalculationResult calculation) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/calculation_result.txt');

      List<CalculationResult> calculations = [];

      // If the file exists, read and parse the JSON content
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          try {
            final List<dynamic> jsonData = json.decode(content);
            calculations = jsonData
                .map((item) => CalculationResult.fromJson(item))
                .toList();
          } catch (e) {
            // Handle cases where the content is not in JSON format
            print('File content is not valid JSON. Overwriting with new data.');
          }
        }
      }

      // Add the new calculation to the list
      calculations.add(calculation);

      // Convert the list to JSON and save it back to the file
      final updatedContent =
          json.encode(calculations.map((e) => e.toJson()).toList());
      await file.writeAsString(updatedContent);
    } catch (e) {
      print('Error storing file: $e');
    }
  }

  Future<List<CalculationResult>> listStorageFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/calculation_result.txt');

      if (!await file.exists()) return [];

      final content = await file.readAsString();
      try {
        final List<dynamic> jsonData = json.decode(content);
        return jsonData
            .map((item) => CalculationResult.fromJson(item))
            .toList()
            .reversed
            .toList();
      } catch (e) {
        print('Error parsing file content as JSON: $e');
        return [];
      }
    } catch (e) {
      print('Error reading file list: $e');
      return [];
    }
  }
}
