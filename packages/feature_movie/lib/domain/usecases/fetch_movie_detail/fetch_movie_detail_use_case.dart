import 'package:core/foundation/networking/models/response_data.dart';
import 'package:core/utils/logger/app_logger.dart';
import 'package:feature_movie/domain/entities/movie/movie.dart';
import 'package:feature_movie/domain/repositories/mbox_movies_repository.dart';
import 'package:feature_movie/domain/repositories/movie_repository.dart';

part 'strategies/fetch_movie_strategies.dart';

enum FetchMovieSource {
  omdbApi,
  mbox,
  ;
}

extension _DetermineFetchMovieStrategy on FetchMovieSource? {
  _FetchMovieDetailStrategy? _strategy({
    required MovieRepository movieRepository,
    required MBoxMoviesRepository mBoxMoviesRepository,
  }) {
    switch (this) {
      case FetchMovieSource.omdbApi:
        return _FetchOMDBMovieDetailStrategy(
          movieRepository: movieRepository,
          mBoxMoviesRepository: mBoxMoviesRepository,
        );
      case FetchMovieSource.mbox:
        return _FetchMBoxMovieDetailStrategy(
          mBoxMoviesRepository: mBoxMoviesRepository,
        );
      case null:
        return null;
    }
  }

  _FetchMovieDetailStrategy determineFetchMovieStrategy({
    required MovieRepository movieRepository,
    required MBoxMoviesRepository mBoxMoviesRepository,
    FetchMovieSource? fallbackMovieSource,
  }) {
    return _FailOverMovieDetailStrategy(
      primaryStrategy: this!._strategy(
        mBoxMoviesRepository: mBoxMoviesRepository,
        movieRepository: movieRepository,
      )!,
      fallbackStrategy: fallbackMovieSource?._strategy(
        mBoxMoviesRepository: mBoxMoviesRepository,
        movieRepository: movieRepository,
      ),
    );
  }
}

class FetchMovieDetailUseCase {
  FetchMovieDetailUseCase({
    required MovieRepository movieRepository,
    required MBoxMoviesRepository mBoxMoviesRepository,
    required FetchMovieSource fetchMovieSource,
    FetchMovieSource? fallbackMovieSource,
  })  : _movieRepository = movieRepository,
        _mBoxMoviesRepository = mBoxMoviesRepository,
        _fetchMovieSource = fetchMovieSource,
        _fallbackMovieSource = fallbackMovieSource;

  final MovieRepository _movieRepository;
  final MBoxMoviesRepository _mBoxMoviesRepository;
  final FetchMovieSource _fetchMovieSource;
  final FetchMovieSource? _fallbackMovieSource;

  Future<FetchMovieResult> execute(String imdbID) async {
    return _fetchMovieSource
        .determineFetchMovieStrategy(
          movieRepository: _movieRepository,
          mBoxMoviesRepository: _mBoxMoviesRepository,
          fallbackMovieSource: _fallbackMovieSource == _fetchMovieSource
              ? null
              : _fallbackMovieSource, // Fallback to null if same source
        )
        .execute(imdbID);
  }
}

class FetchMovieResult {
  FetchMovieResult({
    this.doesMovieExist,
    this.movie,
    this.error,
    this.stackTrace,
  });

  final bool? doesMovieExist;
  final Movie? movie;
  final Object? error;
  final StackTrace? stackTrace;

  bool get hasError => error != null;
}
