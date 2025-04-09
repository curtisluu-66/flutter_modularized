import 'dart:async';

import 'package:core/foundation/networking/models/response_data.dart';
import 'package:core/foundation/riverpod_base/time_base_caching.dart';
import 'package:feature_movie/domain/entities/movie/movie.dart';
import 'package:feature_movie/domain/repositories/movie_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:feature_movie/data/repository_providers.dart';

part 'search_movie_state.dart';
part 'search_movie_state_notifier.g.dart';
part 'search_movie_state_notifier.freezed.dart';

@riverpod
class SearchMoviesNotifier extends _$SearchMoviesNotifier {
  late final MovieRepository _movieRepository;

  @override
  FutureOr<SearchMovieState> build(String query) async {
    ref.cacheFor(const Duration(minutes: 5));

    _movieRepository = await ref.watch(movieRepositoryProvider.future);
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
        searchTerm: query,
        page: nextPage,
      );

      if (searchMovieResponse is ResponseSuccess) {
        final totalResult =
            int.tryParse(searchMovieResponse.data?.totalResults ?? "0") ?? 0;
        final hasMore = totalResult > (nextPage * 10);

        state = AsyncValue.data(
          current.copyWith(
            movies: [...current.movies, ...?searchMovieResponse.data?.search],
            currentPage: nextPage,
            hasMore: hasMore,
            isLoading: false,
            error: null,
          ),
        );
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
