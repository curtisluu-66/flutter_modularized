import 'package:core/utils/logger/app_logger.dart';
import 'package:feature_movie/domain/repositories/movie_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MovieRepositoryImpl implements MovieRepository {
  String? __apiKey;

  Future<String?> get _apiKey async {
    if (__apiKey == null) {
      // The "packages" refers to file path, not a prefix
      await dotenv.load(fileName: "packages/feature_movie/.env");

      __apiKey = dotenv.env['OMDB_API_KEY'];
    }

    return __apiKey;
  }

  @override
  void foo() async {
    AppLogger.i("OMDB API Key is: ${await _apiKey}");
  }
}
