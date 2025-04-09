import 'package:core/ui/components/loading_skeleton.dart';
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
        title: FittedBox(
          child: Text(
            widget.movieShortInfo?.title ?? "-",
          ),
        ),
      ),
      body: SingleChildScrollView(
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
                        return Column(
                          children: [
                            Text(
                              state.movie?.title ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const LoadingSkeleton(
                              height: 20,
                              width: 100,
                            ),
                          ],
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
      bottomNavigationBar: movieDetailState.when(
        data: (state) {
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              child: switch (state.doesMovieExist) {
                null => const LoadingSkeleton(
                    widthFactor: 1,
                    height: 48,
                    borderRadius: 24,
                  ),
                true => Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: null,
                          style: FilledButton.styleFrom(
                            fixedSize: const Size.fromHeight(48),
                          ),
                          child: const Text(
                            "Movie already published",
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: () {
                          // TODO(dev): implement more actions
                        },
                        icon: const Icon(Icons.more_vert),
                      ),
                    ],
                  ),
                false => FilledButton.icon(
                    onPressed: () {
                      if (state.movie != null) {
                        if (state.doesMovieExist == false) {
                          ref
                              .read(
                                movieDetailNotifierProvider(
                                  widget.movieShortInfo?.imdbID ?? "",
                                ).notifier,
                              )
                              .addMovie(movie: state.movie!);
                        }
                      }
                    },
                    label: Text(
                      state.doesMovieExist == false
                          ? "Publish this movie"
                          : "Movie already published",
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    icon: const Icon(Icons.add),
                    iconAlignment: IconAlignment.end,
                    style: FilledButton.styleFrom(
                      fixedSize: const Size.fromHeight(48),
                    ),
                  ),
              });
        },
        error: (_, __) => const SizedBox.shrink(),
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          child: LoadingSkeleton(
            widthFactor: 1,
            height: 48,
            borderRadius: 24,
          ),
        ),
      ),
    );
  }
}
