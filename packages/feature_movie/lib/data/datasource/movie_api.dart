import 'package:dio/dio.dart';
import 'package:feature_movie/domain/entities/movie/movie.dart';
import 'package:feature_movie/domain/responses/search_movies_response.dart';
import 'package:retrofit/retrofit.dart';

part 'movie_api.g.dart';

@RestApi()
abstract class MovieApi {
  factory MovieApi(Dio dio, {String? baseUrl}) = _MovieApi;

  @GET('/')
  Future<HttpResponse<SearchMoviesResponse>> searchMovies({
    @Query('apikey') required String apiKey,
    @Query('s') required String? searchTerm,
    @Query('page') int? page,
  });

  @GET('/')
  Future<HttpResponse<Movie>> getMovieDetailByID({
    @Query('apikey') required String apiKey,
    @Query('i') required String? imdbID,
    @Query('plot') String plot = "full",
  });
}
