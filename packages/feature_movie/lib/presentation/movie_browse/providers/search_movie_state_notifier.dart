import 'dart:async';

import 'package:core/foundation/networking/models/response_data.dart';
import 'package:core/utils/logger/app_logger.dart';
import 'package:feature_movie/data/repositories/movie_repository_impl.dart';
import 'package:feature_movie/domain/entities/movie/movie.dart';
import 'package:feature_movie/domain/repositories/movie_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'search_movie_state.dart';
part 'search_movie_state_notifier.g.dart';
part 'search_movie_state_notifier.freezed.dart';

@riverpod
class SearchMovies extends _$SearchMovies {
  late final MovieRepository _movieRepository;

  KeepAliveLink? _link;

  @override
  FutureOr<SearchMovieState> build(String query) async {
    _movieRepository = await ref.watch(movieRepositoryProvider.future);

    // 👇 Keep this provider alive
    _link = ref.keepAlive();

    // 👇 After 30 seconds, allow Riverpod to dispose this provider
    final timer = Timer(const Duration(seconds: 30), () {
      _link?.close(); // release keepAlive
    });

    // Cancel timer if disposed early
    ref.onDispose(() {
      AppLogger.i(
        "[SearchMoviesStateNotifier] Cache result for term \"$query\" cache has been invalidated!",
      );
      timer.cancel();
    });

    return _initialFetch();
  }

  Future<void> loadMore() async {
    final current = state.asData?.value;
    if (current == null || current.isLoading || !current.hasMore) return;

    state = AsyncValue.data(current.copyWith(isLoading: true));
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final nextPage = current.currentPage + 1;

      final searchMovieResponse = await _movieRepository.searchMovies(
          searchTerm: query, page: nextPage);

      if (searchMovieResponse is ResponseSuccess) {
        final totalResult =
            int.tryParse(searchMovieResponse.data?.totalResults ?? "0") ?? 0;
        final hasMore = totalResult > (nextPage * 10);

        state = AsyncValue.data(current.copyWith(
          movies: [...current.movies, ...?searchMovieResponse.data?.search],
          currentPage: nextPage,
          hasMore: hasMore,
          isLoading: false,
          error: null,
        ));
      } else {
        state = AsyncValue.data(
          current.copyWith(
            isLoading: false,
            error: searchMovieResponse.data?.error ?? "Unexpected Error!",
          ),
        );
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<SearchMovieState> _initialFetch() async {
    try {
      final searchMovieResponse = await _movieRepository.searchMovies(
        searchTerm: query,
        page: 1,
      );

      if (searchMovieResponse is ResponseSuccess) {
        final totalResult =
            int.tryParse(searchMovieResponse.data?.totalResults ?? "0") ?? 0;
        final hasMore = totalResult > 10;

        return SearchMovieState(
          movies: [...?searchMovieResponse.data?.search],
          currentPage: 1,
          hasMore: hasMore,
          error: null,
        );
      } else {
        return SearchMovieState(
          error: searchMovieResponse.data?.error,
        );
      }
    } catch (e) {
      return SearchMovieState(error: e.toString(), hasMore: true);
    }
  }
}
