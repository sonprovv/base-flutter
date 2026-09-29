import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class SecureStorage {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
  Future<void> clear();
}

final class FlutterSecureStorageAdapter implements SecureStorage {
  FlutterSecureStorageAdapter(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<void> clear() => _storage.deleteAll();

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);
}

final secureStorageProvider = Provider<SecureStorage>((ref) {
  const storage = FlutterSecureStorage();
  return FlutterSecureStorageAdapter(storage);
});
