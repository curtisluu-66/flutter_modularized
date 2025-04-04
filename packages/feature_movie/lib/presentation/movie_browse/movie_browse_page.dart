import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/search_movie_state_notifier.dart';

class MovieBrowsePage extends ConsumerStatefulWidget {
  const MovieBrowsePage({super.key});

  @override
  ConsumerState<MovieBrowsePage> createState() => _MovieBrowsePageState();
}

class _MovieBrowsePageState extends ConsumerState<MovieBrowsePage> {
  String searchTerm = '';
  final searchController = TextEditingController();
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      final position = scrollController.position;
      if (position.pixels >= position.maxScrollExtent - 100) {
        // Load more when near bottom
        if (searchTerm.isNotEmpty) {
          ref.read(searchMoviesProvider(searchTerm).notifier).loadMore();
        }
      }
    });
  }

  void onSearchSubmitted(String value) {
    setState(() {
      searchTerm = value.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchState =
        searchTerm.isEmpty ? null : ref.watch(searchMoviesProvider(searchTerm));

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Browse movies"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: onSearchSubmitted,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Search",
                hintText: "Enter movie name",
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: searchTerm.isEmpty
          ? const Center(child: Text('Enter a search term'))
          : searchState?.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (state) {
                  if (state.movies.isEmpty) {
                    return const Center(child: Text('No movies found'));
                  }

                  return ListView.builder(
                    controller: scrollController,
                    itemCount: state.movies.length + (state.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < state.movies.length) {
                        final movie = state.movies[index];
                        return ListTile(
                          title: Text(movie.title),
                          subtitle: Text(movie.year ?? "-1970"),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: state.error?.isNotEmpty != true
                                ? const CircularProgressIndicator()
                                : Text("Error: ${state.error}"),
                          ),
                        );
                      }
                    },
                  );
                },
              ) ??
              const SizedBox.shrink(),
    );
  }
}
