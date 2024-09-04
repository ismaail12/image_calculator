part of 'calculate_image_cubit.dart';

@immutable
sealed class CalculateImageState {}

final class CalculateImageInitial extends CalculateImageState {}

final class CalculateImageLoading extends CalculateImageState {}

class CalculateImageSuccess extends CalculateImageState {
  final String message;
  final CalculationResult result; // Menambahkan CalculationResult

  CalculateImageSuccess(this.message, this.result); // Constructor dengan CalculationResult
}
final class CalculateImageFailure extends CalculateImageState {
  final String error;
  CalculateImageFailure(this.error);
}