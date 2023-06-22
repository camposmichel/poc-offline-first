part of 'todo_cubit.dart';

@immutable
abstract class TodoState {}

class TodoInitialState extends TodoState {}

class TodoLoadingState extends TodoState {}

class TodoLoadedState extends TodoState {
  final List<TodoModel> list;
  TodoLoadedState({
    required this.list,
  });
}

class TodoErrorState extends TodoState {
  final String message;
  TodoErrorState({
    required this.message,
  });
}
