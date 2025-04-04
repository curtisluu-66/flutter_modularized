import 'package:core/foundation/networking/dio/dio_http_client.dart';
import 'package:dio/dio.dart';
import 'package:feature_movie/domain/responses/search_movies_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:retrofit/retrofit.dart';

part 'movie_api.g.dart';

@riverpod
Future<String> fetchMovieBaseUrl(Ref ref) async {
  await dotenv.load(fileName: "packages/feature_movie/.env");

  return dotenv.env["OMDB_BASE_URL"].toString();
}

@riverpod
Future<MovieApi> movieApi(Ref ref) async {
  final dio =
      DioHttpClient(baseUrl: await ref.watch(fetchMovieBaseUrlProvider.future));

  return MovieApi(dio);
}

@RestApi()
abstract class MovieApi {
  factory MovieApi(Dio dio, {String? baseUrl}) = _MovieApi;

  @GET('/')
  Future<HttpResponse<SearchMoviesResponse>> searchMovies({
    @Query('apikey') required String apiKey,
    @Query('s') required String? searchTerm,
    @Query('page') int? page,
  });
}
