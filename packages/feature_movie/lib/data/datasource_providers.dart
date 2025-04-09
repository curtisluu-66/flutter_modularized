import 'package:core/foundation/networking/dio/dio_http_client.dart';
import 'package:feature_movie/data/datasource/movie_api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'datasource_providers.g.dart';

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
