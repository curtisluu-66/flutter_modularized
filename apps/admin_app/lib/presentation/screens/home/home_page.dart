import 'package:feature_movie/domain/repositories/movie_repository.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

part 'bloc/home_bloc.dart';
part 'bloc/home_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            GetIt.I.get<MovieRepository>().foo();
          },
          child: const Text("Click me"),
        ),
      ),
    );
  }
}
