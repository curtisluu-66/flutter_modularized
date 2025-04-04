import 'dart:async';

import 'package:core/foundation/networking/models/response_data.dart';
import 'package:core/utils/logger/app_logger.dart';
import 'package:feature_movie/data/repositories/movie_repository_impl.dart';
import 'package:feature_movie/domain/entities/movie/movie.dart';
import 'package:feature_movie/domain/repositories/movie_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'movie_detail_state_notifier.g.dart';

@riverpod
class MovieDetailNotifier extends _$MovieDetailNotifier {
  late final MovieRepository _movieRepository;

  KeepAliveLink? _link;

  @override
  FutureOr<Movie> build(String imdbID) async {
    _movieRepository = await ref.watch(movieRepositoryProvider.future);

    // 👇 Keep this provider alive
    _link = ref.keepAlive();

    // 👇 After 10 minutes, allow Riverpod to dispose this provider
    final timer = Timer(const Duration(minutes: 10), () {
      _link?.close(); // release keepAlive
    });

    // Cancel timer if disposed early
    ref.onDispose(() {
      AppLogger.i(
        "[MovieDetailStateNotifier] Cache result for film ID \"$imdbID\" cache has been invalidated!",
      );
      timer.cancel();
    });

    return fetchMovieDetails(imdbID);
  }

  Future<Movie> fetchMovieDetails(String imdbID) async {
    try {
      // Only for simulate purpose.
      state = const AsyncValue.loading();

      final movieDetailResponse = await _movieRepository.fetchMovieDetailByID(
        imdbID: imdbID,
      );

      if (movieDetailResponse is ResponseSuccess &&
          movieDetailResponse.data != null) {
        state = AsyncValue.data(
          movieDetailResponse.data!,
        );
      } else {
        state = AsyncValue.error(
          movieDetailResponse.data?.error ?? "Unexpected Error!",
          StackTrace.current,
        );
      }
    } catch (error, stacktrace) {
      AppLogger.e("Fetch movie details failed!", error, stacktrace);
      state = AsyncValue.error(error, stacktrace);
    }

    return state.value!;
  }
}
