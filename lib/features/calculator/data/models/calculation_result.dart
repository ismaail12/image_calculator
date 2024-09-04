import 'dart:convert';

class CalculationResult {
  final String input;
  final double result;
  final String path;

  CalculationResult({
    required this.input,
    required this.result,
    required this.path,
  });

  Map<String, dynamic> toJson() => {
        'input': input,
        'result': result,
        'path': path,
      };


  factory CalculationResult.fromJson(Map<String, dynamic> json) {
    return CalculationResult(
      input: json['input'],
      result: json['result'].toDouble(),
      path: json['path'],
    );
  }

  String toRawJson() => json.encode(toJson());

  factory CalculationResult.fromRawJson(String str) =>
      CalculationResult.fromJson(json.decode(str));
}
