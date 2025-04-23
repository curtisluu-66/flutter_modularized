import 'package:feature_movie/presentation/router.dart';
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
  void _navigateToMovieBrowse() {
    context.push(FeatureMovieRoutes.movieBrowse);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/mbox_logo.png",
          package: "core",
          width: 120,
          fit: BoxFit.contain,
        ),
        centerTitle: false,
        toolbarHeight: kToolbarHeight + 16,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 36),
            ElevatedButton.icon(
              onPressed: _navigateToMovieBrowse,
              icon: const Icon(Icons.movie),
              label: const Text('Browse OMDB Movies'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
