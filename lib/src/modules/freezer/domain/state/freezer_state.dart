import '../entities/freezer.dart';

abstract class FreezerState {}

class InitialFreezerState extends FreezerState {}

class LoadingFreezerState extends FreezerState {}

class SuccessFreezerState extends FreezerState {
  SuccessFreezerState(
    this.freezers,
  );

  final List<Freezer> freezers;
}

class ErrorFreezerState extends FreezerState {
  ErrorFreezerState(this.message);

  final String message;
}
