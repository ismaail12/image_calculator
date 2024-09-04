import 'dart:io';
import 'dart:convert';
import 'package:image_calculator/features/calculator/data/models/calculation_result.dart';
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';

class FileStorageService {
  final String _key = 'unique-key';

  String _encrypt(String data) {
    final bytes = utf8.encode(data);
    final hmacSha256 = Hmac(sha256, utf8.encode(_key));
    final digest = hmacSha256.convert(bytes);
    return hex.encode(digest.bytes) + data;
  }

  String _decrypt(String data) {
    if (data.length <= 64) return ''; 
    return data.substring(64);
  }

  Future<void> storeToFileStorage(CalculationResult calculation) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/calculation_result.txt');
      List<CalculationResult> calculations = [];

      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          try {
            final decryptedContent = _decrypt(content);
            final List<dynamic> jsonData = json.decode(decryptedContent);
            calculations = jsonData
                .map((item) => CalculationResult.fromJson(item))
                .toList();
          } catch (e) {
            print('Error reading or parsing file: $e');
          }
        }
      }

      calculations.add(calculation);
      final updatedContent = json.encode(calculations.map((e) => e.toJson()).toList());
      final encriptedFile = _encrypt(updatedContent);
      await file.writeAsString(encriptedFile);
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

      final decryptedContent = _decrypt(content);
      final List<dynamic> jsonData = json.decode(decryptedContent);
      return jsonData
          .map((item) => CalculationResult.fromJson(item))
          .toList()
          .reversed
          .toList();
    } catch (e) {
      print('Error reading file list: $e');
      return [];
    }
  }
}
