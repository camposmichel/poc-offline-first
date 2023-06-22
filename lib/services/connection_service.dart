import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:poc_localcache/repositories/todo_repository.dart';

class ConnectionService {
  final Connectivity _connectivity = Connectivity();
  final TodoRepository todoRepository;
  bool _wasOffline = false;

  ConnectionService({required this.todoRepository});

  Stream<bool> onConnectionChange() {
    return _connectivity.onConnectivityChanged.map((event) {
      final isOnline = event != ConnectivityResult.none;
      if (_wasOffline && isOnline) {
        todoRepository.syncToBackend();
      }
      _wasOffline = event == ConnectivityResult.none;
      return isOnline;
    });
  }
}
