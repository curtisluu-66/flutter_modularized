part of '../fetch_movie_detail_use_case.dart';

abstract class _FetchMovieDetailStrategy {
  Future<FetchMovieResult> execute(String imdbID);
}

class _FetchOMDBMovieDetailStrategy implements _FetchMovieDetailStrategy {
  _FetchOMDBMovieDetailStrategy({
    required MovieRepository movieRepository,
    required MBoxMoviesRepository mBoxMoviesRepository,
  })  : _movieRepository = movieRepository,
        _mBoxMoviesRepository = mBoxMoviesRepository;

  final MovieRepository _movieRepository;
  final MBoxMoviesRepository _mBoxMoviesRepository;

  @override
  Future<FetchMovieResult> execute(String imdbID) async {
    try {
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

        return FetchMovieResult(
          movie: movieDetailResponse.data,
          doesMovieExist: doesMovieExist,
        );
      } else {
        throw Exception("No movie detail found!");
      }
    } catch (error, stacktrace) {
      return FetchMovieResult(
        error: error,
        stackTrace: stacktrace,
      );
    }
  }
}

class _FetchMBoxMovieDetailStrategy implements _FetchMovieDetailStrategy {
  _FetchMBoxMovieDetailStrategy({
    required MBoxMoviesRepository mBoxMoviesRepository,
  }) : _mBoxMoviesRepository = mBoxMoviesRepository;

  final MBoxMoviesRepository _mBoxMoviesRepository;

  @override
  Future<FetchMovieResult> execute(String imdbID) async {
    try {
      final movie = await _mBoxMoviesRepository.getMovie(imdbID: imdbID);
      return FetchMovieResult(
        movie: movie,
        doesMovieExist: movie != null,
      );
    } catch (error, stacktrace) {
      AppLogger.simpleE("MBox get movie detail failed!", error, stacktrace);
      return FetchMovieResult(
        error: error,
        stackTrace: stacktrace,
      );
    }
  }
}

class _FailOverMovieDetailStrategy implements _FetchMovieDetailStrategy {
  _FailOverMovieDetailStrategy({
    required this.primaryStrategy,
    required this.fallbackStrategy,
  });

  final _FetchMovieDetailStrategy primaryStrategy;
  final _FetchMovieDetailStrategy? fallbackStrategy;

  @override
  Future<FetchMovieResult> execute(String imdbID) async {
    try {
      final result = await primaryStrategy.execute(imdbID);
      return result.hasError
          ? await fallbackStrategy?.execute(imdbID) ?? result
          : result;
    } catch (error, stacktrace) {
      AppLogger.w("Primary strategy failed, trying fallback... Error: $error");
      return await fallbackStrategy?.execute(imdbID) ??
          FetchMovieResult(
            error: Exception("[No movie detail found!] $error"),
            stackTrace: stacktrace,
          );
    }
  }
}
