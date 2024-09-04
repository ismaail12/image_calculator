part of 'get_calculation_result_cubit.dart';

@immutable
sealed class GetCalculationResultState {}

final class GetCalculationResultInitial extends GetCalculationResultState {}
final class GetCalculationResultLoading extends GetCalculationResultState {}

final class GetCalculationResultSuccess extends GetCalculationResultState {
  final List<CalculationResult> results;

  GetCalculationResultSuccess(this.results);
}

final class GetCalculationResultFailure extends GetCalculationResultState {
  final String error;

  GetCalculationResultFailure(this.error);
}