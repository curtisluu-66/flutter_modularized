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
  MovieDetailNotifierProvider get provider =>
      movieDetailNotifierProvider(widget.movieShortInfo?.imdbID ?? "");

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _titleKey = GlobalKey();
  final _showAppBarTitleNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(provider.notifier).reloadDataIfNeeded();
    });
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    final renderBox =
        _titleKey.currentContext?.findRenderObject() as RenderBox?;
    final position = renderBox?.localToGlobal(Offset.zero);

    if (position != null) {
      final shouldShow = position.dy <= kToolbarHeight;
      if (_showAppBarTitleNotifier.value != shouldShow) {
        _showAppBarTitleNotifier.value = shouldShow;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final movieDetailState = ref.watch(provider);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: FittedBox(
            child: ValueListenableBuilder<bool>(
              valueListenable: _showAppBarTitleNotifier,
              builder: (_, show, __) {
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: show ? 1 : 0,
                  child: Text(widget.movieShortInfo?.title ?? "-"),
                );
              },
            ),
          ),
        ),
        centerTitle: false,
      ),
      body: RefreshIndicator(
        onRefresh: ref.read(provider.notifier).refreshData,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: movieDetailState.when(
            data: (state) {
              final movie = state.movie;
              if (movie == null) {
                return const Text('Movie not found');
              }

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title + Year
                    Text(
                      '${movie.title} ${movie.year != null ? '(${movie.year})' : ''}',
                      key: _titleKey,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    /// Poster
                    if (movie.poster != null && movie.poster!.isNotEmpty)
                      Center(
                        child: MoviePosterWidget(
                          poster: widget.movieShortInfo?.poster,
                          borderRadius: 12,
                        ),
                      ),

                    const SizedBox(height: 16),

                    /// Metadata Section
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        _MovieInfoChip(
                          label: "Rated",
                          value: movie.rated,
                        ),
                        _MovieInfoChip(
                          label: "Runtime",
                          value: movie.runtime,
                        ),
                        _MovieInfoChip(
                          label: "Genre",
                          value: movie.genre,
                        ),
                        _MovieInfoChip(
                          label: "IMDB",
                          value: movie.imdbRating,
                        ),
                        _MovieInfoChip(
                          label: "Metascore",
                          value: movie.metascore,
                        ),
                        _MovieInfoChip(
                          label: "Likes",
                          value: movie.likesCount.toString(),
                        ),
                        if (movie.isEditorChoice == true)
                          Chip(
                            label: const Text(
                              "Editor’s Choice ⭐",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            avatar: const Icon(
                              Icons.auto_awesome, // sparkles icon ✨
                              color: Colors.white,
                              size: 18,
                            ),
                            backgroundColor: Colors.amber.shade600,
                            elevation: 2,
                            shadowColor: Colors.amberAccent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: Colors.amber.shade700,
                                width: 1,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    /// Plot Summary
                    if (movie.plot != null)
                      Text(
                        movie.plot!,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),

                    const SizedBox(height: 16),

                    /// Crew Info
                    if (movie.director != null)
                      _InfoLine(
                        title: "Director",
                        value: movie.director!,
                      ),
                    if (movie.writer != null)
                      _InfoLine(
                        title: "Writer",
                        value: movie.writer!,
                      ),
                    if (movie.actors != null)
                      _InfoLine(
                        title: "Cast",
                        value: movie.actors!,
                      ),

                    if (movie.language != null)
                      _InfoLine(
                        title: "Language",
                        value: movie.language!,
                      ),
                    if (movie.country != null)
                      _InfoLine(
                        title: "Country",
                        value: movie.country!,
                      ),
                    if (movie.awards != null)
                      _InfoLine(
                        title: "Awards",
                        value: movie.awards!,
                      ),

                    const SizedBox(height: 16),

                    /// Ratings
                    if (movie.ratings != null && movie.ratings!.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Ratings",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...movie.ratings!.map(
                            (rating) => Text(
                              "${rating.source}: ${rating.value}",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 24),
                  ],
                ),
              );
            },
            error: (error, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 40,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Failed to load movie details.\n${error.toString()}",
                  ),
                ],
              ),
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LoadingSkeleton(height: 30, width: 200),
                  SizedBox(height: 8),
                  LoadingSkeleton(
                    height: 220,
                    width: double.infinity,
                  ),
                  SizedBox(height: 16),
                  LoadingSkeleton(height: 16, width: 300),
                  SizedBox(height: 8),
                  LoadingSkeleton(height: 16, width: 250),
                  SizedBox(height: 8),
                  LoadingSkeleton(height: 16, width: 280),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: movieDetailState.when(
        data: (state) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                            .read(provider.notifier)
                            .addMovie(movie: state.movie!);
                      }
                    }
                  },
                  label: const Text(
                    "Publish this movie",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  icon: const Icon(Icons.add),
                  iconAlignment: IconAlignment.end,
                  style: FilledButton.styleFrom(
                    fixedSize: const Size.fromHeight(48),
                  ),
                ),
            },
          );
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

class _MovieInfoChip extends StatelessWidget {
  final String label;
  final String? value;

  const _MovieInfoChip({required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    if (value == null || value!.isEmpty) return const SizedBox.shrink();
    return Chip(
      label: Text("$label: $value"),
      backgroundColor: Colors.grey[200],
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String title;
  final String value;

  const _InfoLine({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          text: "$title: ",
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
