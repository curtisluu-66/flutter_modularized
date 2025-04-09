import 'package:core/foundation/networking/models/response_data.dart';
import 'package:feature_movie/data/datasource/movie_api.dart';
import 'package:feature_movie/domain/entities/movie/movie.dart';
import 'package:feature_movie/domain/repositories/movie_repository.dart';
import 'package:feature_movie/domain/responses/search_movies_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MovieRepositoryImpl implements MovieRepository {
  MovieRepositoryImpl({
    required MovieApi movieApi,
  }) : _movieApi = movieApi;

  final MovieApi _movieApi;

  String? __apiKey;

  Future<String> get _apiKey async {
    if (__apiKey == null) {
      // The "packages" refers to file path, not a prefix
      await dotenv.load(fileName: "packages/feature_movie/.env");

      __apiKey = dotenv.env['OMDB_API_KEY'];
    }

    return __apiKey ?? "";
  }

  @override
  Future<ResponseData<SearchMoviesResponse>> searchMovies({
    required String? searchTerm,
    int? page,
  }) async {
    return convertToResponseData(
      _movieApi.searchMovies(
        apiKey: await _apiKey,
        searchTerm: searchTerm,
        page: page,
      ),
    );
  }

  @override
  Future<ResponseData<Movie>> fetchMovieDetailByID({
    required String imdbID,
  }) async {
    return convertToResponseData(
      _movieApi.getMovieDetailByID(
        apiKey: await _apiKey,
        imdbID: imdbID,
      ),
    );
  }
}
