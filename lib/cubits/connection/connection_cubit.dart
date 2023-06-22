import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poc_localcache/configs/dependencies.dart';
import 'package:poc_localcache/repositories/todo_repository.dart';
import 'package:poc_localcache/services/connection_service.dart';

part 'connection_state.dart';

class AppConnectionCubit extends Cubit<AppConnectionState> {
  final ConnectionService _connectionService = ConnectionService(
    todoRepository: Dependencies.resolve<TodoRepository>(),
  );

  AppConnectionCubit() : super(AppConnectionInitialState());

  void init() {
    _connectionService.onConnectionChange().listen((event) {
      if (event) {
        emit(AppConnectionOnlineState());
      } else {
        emit(AppConnectionOfflineState());
      }
    });
  }
}
