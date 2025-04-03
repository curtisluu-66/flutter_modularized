import 'package:core/foundation/networking/dio/dio_http_client.dart';
import 'package:feature_movie/data/datasource/movie_api.dart';
import 'package:flutter/material.dart';

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
            final httpClient =
                DioHttpClient(baseUrl: "https://www.omdbapi.com");
            final movieApi = MovieApi(httpClient);

            movieApi.searchMovies(apiKey: "af657582", searchTerm: "John");
          },
          child: const Text("Click me"),
        ),
      ),
    );
  }
}
