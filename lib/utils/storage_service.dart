import 'package:get_storage/get_storage.dart';

class StorageService {
  final GetStorage _storage = GetStorage();

  /// Save a value to storage
  Future<void> write(String key, dynamic value) async {
    await _storage.write(key, value);
  }

  /// Read a value from storage
  T? read<T>(String key) {
    return _storage.read<T>(key);
  }

  /// Check if a key exists in storage
  bool hasKey(String key) {
    return _storage.hasData(key);
  }

  /// Remove a value from storage
  Future<void> remove(String key) async {
    await _storage.remove(key);
  }

  /// Clear all data from storage
  Future<void> clear() async {
    await _storage.erase();
  }
}
