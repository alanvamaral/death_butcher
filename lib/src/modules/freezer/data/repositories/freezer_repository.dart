import 'dart:convert';

import '../../../core/services/local_storage/local_storage_service.dart';
import '../../domain/entities/freezer.dart';

abstract class FreezerRepository {
  Future<void> addFreezer(Freezer freezer);
  Future<List<Freezer>> getFreezers();
  Future<void> updateFreezer(Freezer freezer);
  Future<void> deleteFreezer(int freezerId);
}

class RemoteFreezerRepository implements FreezerRepository {
  RemoteFreezerRepository(this._localStorage);

  final LocalStorageService _localStorage;

  @override
  Future<List<Freezer>> getFreezers() async {
    final freezersString = await _localStorage.getData('freezers');
    if (freezersString.isNotEmpty) {
      return freezersString
          .map((freezerString) => Freezer.fromJson(jsonDecode(freezerString)))
          .toList();
    } else {
      return [];
    }
  }

  @override
  Future<void> addFreezer(Freezer novoFreezer) async {
    List<String> freezerJsonList = await _localStorage.getData('freezers');
    freezerJsonList.add(json.encode(novoFreezer.toJson()));
    await _localStorage.saveData('freezers', freezerJsonList);
  }

  @override
  Future<void> deleteFreezer(int freezerId) async {
    final freezersJson = await _localStorage.getData('freezers');
    if (freezersJson.isEmpty) return;
    final updatedList = freezersJson.where((freezerString) {
      final freezer = Freezer.fromJson(jsonDecode(freezerString));
      return freezer.id != freezerId;
    }).toList();
    await _localStorage.saveData('freezers', updatedList);
  }

  @override
  Future<void> updateFreezer(Freezer updatedFreezer) async {
    final freezersJson = await _localStorage.getData('freezers');
    if (freezersJson.isEmpty) return;
    int index = freezersJson.indexWhere((freezerString) {
      final freezer = Freezer.fromJson(jsonDecode(freezerString));
      return freezer.id == updatedFreezer.id;
    });

    if (index != -1) {
      freezersJson[index] = jsonEncode(updatedFreezer.toJson());
      await _localStorage.saveData('freezers', freezersJson);
    }
  }
}
