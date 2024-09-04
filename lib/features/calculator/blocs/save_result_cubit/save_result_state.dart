part of 'save_result_cubit.dart';

@immutable
sealed class SaveResultState {}

final class SaveResultInitial extends SaveResultState {}


final class SaveResultLoading extends SaveResultState {}

final class SaveResultSuccess extends SaveResultState {
  final String message;

  SaveResultSuccess(this.message);
}

final class SaveResultFailure extends SaveResultState {
  final String error;

  SaveResultFailure(this.error);
}