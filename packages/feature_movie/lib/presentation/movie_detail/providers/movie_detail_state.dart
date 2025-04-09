part of 'movie_detail_state_notifier.dart';

@freezed
class MovieDetailState with _$MovieDetailState {
  MovieDetailState._();

  factory MovieDetailState({
    final Movie? movie,
    final bool? doesMovieExist,
  }) = _MovieDetailState;
}
