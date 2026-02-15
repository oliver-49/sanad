part of 'sanad_cubit.dart';

@immutable
sealed class SanadState {}

final class SanadInitial extends SanadState {}
final class SanadPostImageLoading extends SanadState {}
final class SanadPostImageLoaded extends SanadState {
  final Map response ;

  SanadPostImageLoaded(this.response);

}
final class SanadPostImageError extends SanadState {
   final String Error;
  SanadPostImageError(this.Error);
}
