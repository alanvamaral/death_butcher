import 'package:flutter/widgets.dart';

import '../../data/repositories/meat_repository.dart';
import '../entities/meat.dart';
import '../state/meat_state.dart';

class MeatViewModel extends ValueNotifier<MeatStates> {
  MeatViewModel(this._repository) : super(InitialMeatState());

  final MeatRepository _repository;

  List<Meat> meats = [];

  Future getMeats() async {
    value = LoadingMeatState();

    try {
      meats = await _repository.getMeats();

      value = SuccessMeatState(meats);
    } catch (e) {
      value = ErrorMeatState(e.toString());
    }
  }

  Future addMeat(Meat meat) async {
    try {
      await _repository.addMeat(meat);
      await getMeats();
    } catch (e) {
      value = ErrorMeatState(e.toString());
    }
  }

  Future removeMeat(Meat meat) async {
    try {
      await _repository.deleteMeat(meat.id);
      await getMeats();
    } catch (e) {
      value = ErrorMeatState(e.toString());
    }
  }
}
