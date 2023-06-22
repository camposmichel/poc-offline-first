import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poc_localcache/models/todo_model.dart';
import 'package:poc_localcache/repositories/todo_repository.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  final TodoRepository repository;

  TodoCubit({
    required this.repository,
  }) : super(TodoInitialState());

  void init() async {
    emit(TodoLoadingState());
    try {
      repository.getBoxStream().listen((todoList) {
        emit(TodoLoadedState(list: todoList));
      });
      await repository.loadList();
    } catch (e) {
      emit(TodoErrorState(message: e.toString()));
    }
  }

  void add(String title) async {
    try {
      await repository.add(title);
    } catch (e) {
      emit(TodoErrorState(message: e.toString()));
    }
  }

  void delete(String id) async {
    try {
      await repository.delete(id);
    } catch (e) {
      emit(TodoErrorState(message: e.toString()));
    }
  }
}
