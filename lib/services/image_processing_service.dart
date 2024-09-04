import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_calculator/features/calculator/data/models/calculation_result.dart';
import 'package:math_expressions/math_expressions.dart';
import 'dart:io';

class ImageProcessingService {
  Future<CalculationResult?> processImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer();
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();

    String expression = recognizedText.blocks
        .map((block) => block.text)
        .firstWhere((line) => _isArithmeticExpression(line), orElse: () => '');

    if (expression.isEmpty) {
      print('Tidak ada ekspresi aritmatika yang ditemukan.');
      return null;
    }

    try {
      Parser p = Parser();
      Expression exp = p.parse(expression);
      double result = exp.evaluate(EvaluationType.REAL, ContextModel());
      return CalculationResult(
        input: expression,
        result: result,
        path: imageFile.path, // Menambahkan path di sini
      );
    } catch (e) {
      print('Gagal menghitung ekspresi: $expression');
      return null;
    }
  }

  bool _isArithmeticExpression(String input) {
    return RegExp(r'^[0-9\+\-\*/\(\) ]+$').hasMatch(input);
  }
}
