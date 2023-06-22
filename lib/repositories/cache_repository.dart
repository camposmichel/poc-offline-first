import 'package:hive/hive.dart';

class CacheRepository<T> {
  final String cacheKey;
  final dynamic defaultValue;

  CacheRepository({
    required this.cacheKey,
    required this.defaultValue,
  });

  Stream<T> getBoxStream() async* {
    final box = await Hive.openBox(cacheKey);
    yield* box.watch().map((event) => event.value as T);
  }

  Future<T> get(String path) async {
    final box = await Hive.openBox(cacheKey);
    final data = await box.get(path, defaultValue: defaultValue) as T;
    return data;
  }

  Future add(String path, T data) async {
    final box = await Hive.openBox(cacheKey);
    return await box.put(path, data);
  }

  Future clear() async {
    final box = await Hive.openBox(cacheKey);
    return await box.clear();
  }
}
