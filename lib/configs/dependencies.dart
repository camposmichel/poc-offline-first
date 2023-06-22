import 'package:get_it/get_it.dart';
import 'package:poc_localcache/repositories/todo_repository.dart';

class Dependencies {
  static final _getIt = GetIt.instance;

  Dependencies._();

  static T resolve<T extends Object>() => _getIt.get<T>();
  static Future<void> allReady() => _getIt.allReady();

  static void registerInstances() {
    _getIt.registerSingleton<TodoRepository>(TodoRepository());
  }
}
