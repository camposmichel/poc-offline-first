import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poc_localcache/cubits/connection/connection_cubit.dart';
import 'package:poc_localcache/cubits/todo/todo_cubit.dart';
import 'package:poc_localcache/models/todo_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    context.read<AppConnectionCubit>().init();
    context.read<TodoCubit>().init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Future<void> initConnectivity() async {
  //   late ConnectivityResult result;
  //   try {
  //     result = await _connectivity.checkConnectivity();
  //   } on PlatformException catch (e) {
  //     print(e.toString());
  //     return;
  //   }
  //   if (!mounted) {
  //     return Future.value(null);
  //   }
  //   return _updateConnectionStatus(result);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: BlocBuilder<TodoCubit, TodoState>(
        builder: (_, state) {
          if (state is TodoLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is TodoErrorState) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is TodoLoadedState) {
            return ListView.builder(
              itemCount: state.list.length,
              itemBuilder: (_, index) {
                return todoItem(state.list[index]);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        onPressed: _showDialog,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BlocBuilder<AppConnectionCubit, AppConnectionState>(
        builder: (_, state) {
          if (state is AppConnectionOfflineState) {
            return Container(
              color: Colors.red,
              height: 50,
              child: const Center(
                child: Text(
                  'Modo Offline',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget todoItem(TodoModel model) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(model.id),
          Row(
            children: [
              Text(
                model.title,
                style: const TextStyle(fontSize: 18),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => context.read<TodoCubit>().delete(model.id),
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
          Text(model.updateAt ?? ''),
        ],
      ),
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Add Todo'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Todo',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<TodoCubit>().add(controller.text);
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    ).whenComplete(() => controller.clear());
  }
}
