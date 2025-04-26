import 'package:shared_preferences/shared_preferences.dart';

import 'error.dart';

abstract class LocalStorageService {
  Future saveData(String key, List<String> value);
  Future<List<String>> getData(String key);
  Future removeData(String key);
}

class RemoteLocalStorageService implements LocalStorageService {
  RemoteLocalStorageService();

  @override
  Future saveData(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      await prefs.setStringList(key, value);
    } catch (e, s) {
      throw LocalStorageException(e.toString(), s);
    }
  }

  @override
  Future<List<String>> getData(String key) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      final value = prefs.getStringList(key);
      return value ?? [];
    } catch (e, s) {
      throw LocalStorageException(e.toString(), s);
    }
  }

  @override
  Future removeData(String key) async {
    final prefs = await SharedPreferences.getInstance();

    try {
      await prefs.remove(key);
    } catch (e, s) {
      throw LocalStorageException(e.toString(), s);
    }
  }
}
