import 'dart:async';

import 'package:core/constants/constants.dart';
import 'package:core/foundation/riverpod_base/time_base_caching.dart';
import 'package:core/utils/logger/app_logger.dart';
import 'package:feature_movie/data/repository_providers.dart';
import 'package:feature_movie/domain/entities/movie/movie.dart';
import 'package:feature_movie/domain/repositories/mbox_movies_repository.dart';
import 'package:feature_movie/domain/repositories/movie_repository.dart';
import 'package:feature_movie/domain/usecases/fetch_movie_detail/fetch_movie_detail_use_case.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'movie_detail_state.dart';
part 'movie_detail_state_notifier.g.dart';
part 'movie_detail_state_notifier.freezed.dart';

@riverpod
class MovieDetailNotifier extends _$MovieDetailNotifier {
  late final MovieRepository _movieRepository;
  late final MBoxMoviesRepository _mBoxMoviesRepository;
  FetchMovieDetailUseCase? _fetchMovieDetailUseCase;

  @override
  FutureOr<MovieDetailState> build(String imdbID) async {
    ref.cacheFor(const Duration(minutes: 5));

    _movieRepository = await ref.watch(movieRepositoryProvider.future);
    _mBoxMoviesRepository = await ref.watch(mBoxMoviesRepositoryProvider);

    return await _fetchMovieDetail();
  }

  Future<MovieDetailState> _fetchMovieDetail() async {
    _fetchMovieDetailUseCase ??= FetchMovieDetailUseCase(
      movieRepository: _movieRepository,
      mBoxMoviesRepository: _mBoxMoviesRepository,
      fetchMovieSource:
          await kIsAdminApp ? FetchMovieSource.omdbApi : FetchMovieSource.mbox,
      fallbackMovieSource: await kIsAdminApp ? null : FetchMovieSource.omdbApi,
    );

    final fetchMovieResult = await _fetchMovieDetailUseCase!.execute(imdbID);

    if (fetchMovieResult.hasError) {
      throw fetchMovieResult.error!;
    } else {
      return MovieDetailState(
        movie: fetchMovieResult.movie,
        doesMovieExist: fetchMovieResult.doesMovieExist,
      );
    }
  }

  Future<void> refreshData() async {
    // Avoid refresh while loading.
    if (state.isLoading) return;

    try {
      // state = const AsyncValue.loading();
      final fetchMovieResult = await _fetchMovieDetail();
      state = AsyncValue.data(
        MovieDetailState(
          movie: fetchMovieResult.movie,
          doesMovieExist: fetchMovieResult.doesMovieExist,
        ),
      );
    } catch (error, stacktrace) {
      AppLogger.e("Fetch movie details failed!", error, stacktrace);
      state = AsyncValue.error(error, stacktrace);
    }
  }

  void addMovie({required Movie movie}) async {
    if (!state.hasValue) return;
    final snapshot = state;

    state = AsyncValue.data(
      snapshot.value!.copyWith(
        doesMovieExist: null,
      ),
    );

    state = AsyncValue.data(
      snapshot.value!.copyWith(
        doesMovieExist:
            await _mBoxMoviesRepository.addMovie(movie: movie) ? true : null,
      ),
    );
  }

  void reloadDataIfNeeded() {
    if (state.hasError) {
      AppLogger.i(
        "Initialize page with error state, so data will be reloaded.",
      );

      refreshData();
    }
  }
}
