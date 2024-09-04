part of 'get_calculation_result_cubit.dart';

@immutable
sealed class GetCalculationResultState {}

final class GetCalculationResultInitial extends GetCalculationResultState {}
final class GetCalculationResultLoading extends GetCalculationResultState {}

final class GetCalculationResultSuccess extends GetCalculationResultState {
  final List<CalculationResult> fromFiles;
  final List<CalculationResult> fromDatabase;

  GetCalculationResultSuccess(this.fromFiles, this.fromDatabase);
}

final class GetCalculationResultFailure extends GetCalculationResultState {
  final String error;

  GetCalculationResultFailure(this.error);
}