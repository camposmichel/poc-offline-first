import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poc_localcache/configs/dependencies.dart';
import 'package:poc_localcache/cubits/connection/connection_cubit.dart';
import 'package:poc_localcache/cubits/todo/todo_cubit.dart';
import 'package:poc_localcache/repositories/todo_repository.dart';

class CubitProviders {
  CubitProviders._();

  static final List<BlocProvider> providers = [
    BlocProvider<TodoCubit>(
      create: (_) => TodoCubit(
        repository: Dependencies.resolve<TodoRepository>(),
      ),
    ),
    BlocProvider<AppConnectionCubit>(create: (_) => AppConnectionCubit()),
  ];
}
