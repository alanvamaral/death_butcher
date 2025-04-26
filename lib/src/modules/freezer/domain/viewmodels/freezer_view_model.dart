import 'package:flutter/cupertino.dart';

import '../../data/repositories/freezer_repository.dart';
import '../entities/freezer.dart';
import '../entities/meat.dart';
import '../state/freezer_state.dart';

class FreezerViewModel extends ValueNotifier<FreezerState> {
  FreezerViewModel(this._repository) : super(InitialFreezerState());

  final FreezerRepository _repository;

  List<Freezer> freezers = [];
  List<Meat> meats = [];

  Future getFreezers() async {
    value = LoadingFreezerState();

    try {
      freezers = await _repository.getFreezers();

      value = SuccessFreezerState(freezers);
    } catch (e) {
      value = ErrorFreezerState(e.toString());
    }
  }

  Future addFreezer(Freezer freezer) async {
    try {
      await _repository.addFreezer(freezer);
      await getFreezers();
    } catch (e) {
      value = ErrorFreezerState(e.toString());
    }
  }

  Future removeFreezer(Freezer freezer) async {
    try {
      await _repository.deleteFreezer(freezer.id);
      await getFreezers();
    } catch (e) {
      value = ErrorFreezerState(e.toString());
    }
  }
}
