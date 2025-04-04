import 'package:feature_movie/domain/entities/movie/movie.dart';
import 'package:feature_movie/presentation/movie_detail/providers/movie_detail_state_notifier.dart';
import 'package:feature_movie/src/ui/movie_poster_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieDetailPage extends ConsumerStatefulWidget {
  const MovieDetailPage({
    super.key,
    required this.movieShortInfo,
  });

  final Movie? movieShortInfo;

  @override
  ConsumerState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends ConsumerState<MovieDetailPage> {
  @override
  Widget build(BuildContext context) {
    final movieDetailState = ref.watch(
      movieDetailNotifierProvider(widget.movieShortInfo?.imdbID ?? ""),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Center(
                child: LimitedBox(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                  child: MoviePosterWidget(
                    poster: widget.movieShortInfo?.poster,
                    borderRadius: 12,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    Text(
                      widget.movieShortInfo?.title ?? "-",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    movieDetailState.when(
                      data: (state) {
                        return Text(
                          state.released ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        );
                      },
                      error: (error, _) => Text("Error: $error"),
                      loading: () => const CircularProgressIndicator(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
