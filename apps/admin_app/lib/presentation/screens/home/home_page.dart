import 'package:admin_app/presentation/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'bloc/home_bloc.dart';
part 'bloc/home_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      // Do computation
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            context.push(AppRoutes.movieBrowse);
          },
          child: const Text("Browse movies"),
        ),
      ),
    );
  }
}
