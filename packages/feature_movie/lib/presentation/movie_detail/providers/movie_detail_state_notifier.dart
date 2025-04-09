import 'dart:async';

import 'package:core/foundation/networking/models/response_data.dart';
import 'package:core/foundation/riverpod_base/time_base_caching.dart';
import 'package:core/utils/logger/app_logger.dart';
import 'package:feature_movie/data/repository_providers.dart';
import 'package:feature_movie/domain/entities/movie/movie.dart';
import 'package:feature_movie/domain/repositories/mbox_movies_repository.dart';
import 'package:feature_movie/domain/repositories/movie_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'movie_detail_state.dart';
part 'movie_detail_state_notifier.g.dart';
part 'movie_detail_state_notifier.freezed.dart';

@riverpod
class MovieDetailNotifier extends _$MovieDetailNotifier {
  late final MovieRepository _movieRepository;
  late final MBoxMoviesRepository _mBoxMoviesRepository;

  @override
  FutureOr<MovieDetailState> build(String imdbID) async {
    ref.cacheFor(const Duration(minutes: 5));

    _movieRepository = await ref.watch(movieRepositoryProvider.future);
    _mBoxMoviesRepository = await ref.watch(mBoxMoviesRepositoryProvider);

    return fetchMovieDetails(imdbID);
  }

  Future<MovieDetailState> fetchMovieDetails(String imdbID) async {
    try {
      // Only for simulate purpose.
      state = const AsyncValue.loading();

      final movieDetailResponse = await _movieRepository.fetchMovieDetailByID(
        imdbID: imdbID,
      );

      if (movieDetailResponse is ResponseSuccess &&
          movieDetailResponse.data != null) {
        bool? doesMovieExist;

        if (movieDetailResponse.data!.imdbID != null) {
          doesMovieExist = await _mBoxMoviesRepository.doesMovieExist(
            imdbID: movieDetailResponse.data!.imdbID!,
          );
        }

        state = AsyncValue.data(
          MovieDetailState(
            movie: movieDetailResponse.data,
            doesMovieExist: doesMovieExist,
          ),
        );
      } else {
        state = AsyncValue.error(
          "Unexpected Error!",
          StackTrace.current,
        );
      }
    } catch (error, stacktrace) {
      AppLogger.e("Fetch movie details failed!", error, stacktrace);
      state = AsyncValue.error(error, stacktrace);
    }

    return state.value!;
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
}
