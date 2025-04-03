import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'movie_api.g.dart';

@RestApi()
abstract class MovieApi {
  factory MovieApi(Dio dio, {String? baseUrl}) = _MovieApi;

  @GET('/')
  Future<HttpResponse<dynamic>> searchMovies({
    @Query('apikey') required String apiKey,
    @Query('s') required String? searchTerm,
    @Query('page') int? page,
  });
}
