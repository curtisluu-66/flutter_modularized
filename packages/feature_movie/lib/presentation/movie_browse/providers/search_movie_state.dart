part of 'search_movie_state_notifier.dart';

@freezed
class SearchMovieState with _$SearchMovieState {
  SearchMovieState._();

  factory SearchMovieState({
    @Default([]) final List<Movie> movies,
    @Default(1) final int currentPage,
    @Default(false) final bool hasMore,
    @Default(false) final bool isLoading,
    @Default(null) final String? error,
  }) = _SearchMovieState;
}
