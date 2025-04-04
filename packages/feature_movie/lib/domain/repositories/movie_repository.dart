import 'package:core/foundation/networking/models/response_data.dart';
import 'package:feature_movie/domain/entities/movie/movie.dart';
import 'package:feature_movie/domain/responses/search_movies_response.dart';

abstract class MovieRepository {
  Future<ResponseData<SearchMoviesResponse>> searchMovies({
    required String? searchTerm,
    int? page,
  });

  Future<ResponseData<Movie>> fetchMovieDetailByID({
    required String imdbID,
  });
}
