import 'dart:convert';

import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:poc_localcache/models/todo_model.dart';
import 'package:poc_localcache/repositories/cache_repository.dart';
import 'package:uuid/uuid.dart';

class TodoRepository {
  late final Dio _dio;
  // final String baseUrl = 'http://10.0.2.2:3000';
  final String baseUrl = 'https://stflqx-ip-177-192-87-64.tunnelmole.com';
  late final CacheRepository<List<String>> _cacheRepository;
  final _uuidGenerator = const Uuid();

  List<String> _todoList = List.empty();

  TodoRepository() {
    _dio = Dio();
    _dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    // _dio.interceptors.add(LogInterceptor(
    //   requestBody: true,
    //   responseBody: true,
    // ));
    _cacheRepository = CacheRepository<List<String>>(
      cacheKey: 'todo',
      defaultValue: _todoList,
    );
  }

  Stream<List<TodoModel>> getBoxStream() {
    return _cacheRepository.getBoxStream().map<List<TodoModel>>((list) {
      _todoList = list;
      return _todoList
          .map<TodoModel>((data) => TodoModel.fromMap(jsonDecode(data)))
          .toList();
    });
  }

  Future syncToBackend() async {
    final listCache = await _cacheRepository.get('$baseUrl/Titulos');
    final listMapped = listCache
        .map<TodoModel>((data) => TodoModel.fromMap(jsonDecode(data)))
        .toList();
    await _sendToBackend(listMapped);
    await loadList();
    // _todoList = listCache;
    // _updateCache();
  }

  Future loadList() async {
    final listCache = await _cacheRepository.get('$baseUrl/Titulos');
    _todoList = listCache;
    _updateCache();

    try {
      final response = await _dio.get('$baseUrl/Titulos');
      final List<String> list = response.data
          .map<String>((e) => jsonEncode(e as Map<String, dynamic>))
          .toList();
      _todoList = list;
      _updateCache();
    } catch (e) {
      print(e);
    }
  }

  Future add(String title) async {
    final newItem = TodoModel(
      title: title,
      id: 'mobile-${_uuidGenerator.v1()}',
      updateAt: DateTime.now().toIso8601String(),
    );
    _todoList.add(jsonEncode(newItem.toMap()));
    _updateCache();

    _sendToBackend([newItem]).then((response) {
      final list = response.data as List<dynamic>;
      _todoList.last = jsonEncode(list.first);
      _updateCache();
    }).catchError((e) {
      print(e);
    });
  }

  Future delete(String id) async {
    _todoList.removeWhere((element) {
      final model = TodoModel.fromMap(jsonDecode(element));
      return model.id == id;
    });
    _updateCache();

    try {
      _dio.delete('$baseUrl/Titulos/$id');
    } catch (e) {
      print(e);
    }
  }

  Future<Response<dynamic>> _sendToBackend(List<TodoModel> list) async {
    return _dio.post(
      '$baseUrl/Titulos',
      data: list.map((e) => e.toMap()).toList(),
      options: Options(contentType: Headers.jsonContentType),
    );
  }

  _updateCache() {
    _cacheRepository.add('$baseUrl/Titulos', _todoList);
  }
}
