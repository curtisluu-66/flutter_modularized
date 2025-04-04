// ignore_for_file: invalid_annotation_target
import 'package:feature_movie/domain/entities/movie/movie.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_movies_response.freezed.dart';
part 'search_movies_response.g.dart';

@freezed
class SearchMoviesResponse with _$SearchMoviesResponse {
  SearchMoviesResponse._();

  factory SearchMoviesResponse({
    @JsonKey(name: 'Response') String? response,
    @JsonKey(name: 'Search') List<Movie>? search,
    @JsonKey(name: 'Error') String? error,
    String? totalResults,
  }) = _SearchMoviesResponse;

  bool get success => response == "True";

  factory SearchMoviesResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchMoviesResponseFromJson(json);
}
