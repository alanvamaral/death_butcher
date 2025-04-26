import '../entities/meat.dart';

abstract class MeatStates {}

class InitialMeatState extends MeatStates {}

class LoadingMeatState extends MeatStates {}

class SuccessMeatState extends MeatStates {
  SuccessMeatState(this.meats);

  final List<Meat> meats;
}

class ErrorMeatState extends MeatStates {
  ErrorMeatState(this.message);

  final String message;
}
