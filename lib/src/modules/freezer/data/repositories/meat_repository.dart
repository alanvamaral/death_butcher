import 'dart:convert';

import '../../../core/services/local_storage/local_storage_service.dart';
import '../../domain/entities/meat.dart';

abstract class MeatRepository {
  Future<void> addMeat(Meat meat);
  Future<List<Meat>> getMeats();
  Future<void> updateMeat(Meat meat);
  Future<void> deleteMeat(int meatId);
}

class RemoteMeatRepository implements MeatRepository {
  RemoteMeatRepository(this._localStorage);

  final LocalStorageService _localStorage;

  @override
  Future<List<Meat>> getMeats() async {
    final meatsString = await _localStorage.getData('meats');
    if (meatsString.isNotEmpty) {
      return meatsString
          .map((meatString) => Meat.fromJson(jsonDecode(meatString)))
          .toList();
    } else {
      return [];
    }
  }

  @override
  Future<void> addMeat(Meat meat) async {
    List<String> meatJsonList = await _localStorage.getData('meats');
    meatJsonList.add(json.encode(meat.toJson()));
    await _localStorage.saveData('meats', meatJsonList);
  }

  @override
  Future<void> deleteMeat(int meatId) async {
    final meatsJson = await _localStorage.getData('meats');
    if (meatsJson.isEmpty) return;
    final updatedList = meatsJson.where((meatString) {
      final meat = Meat.fromJson(jsonDecode(meatString));
      return meat.id != meatId;
    }).toList();
    await _localStorage.saveData('meats', updatedList);
  }

  @override
  Future<void> updateMeat(Meat updatedMeat) async {
    final meatsJson = await _localStorage.getData('meats');
    if (meatsJson.isEmpty) return;
    int index = meatsJson.indexWhere((meatString) {
      final meat = Meat.fromJson(jsonDecode(meatString));
      return meat.id == updatedMeat.id;
    });

    if (index != -1) {
      meatsJson[index] = jsonEncode(updatedMeat.toJson());
      await _localStorage.saveData('meats', meatsJson);
    }
  }
}
