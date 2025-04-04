import 'package:core/utils/formatter/safe_casting.dart';
import 'package:feature_movie/domain/entities/movie/movie.dart';
import 'package:feature_movie/presentation/movie_browse/movie_browse_page.dart';
import 'package:feature_movie/presentation/movie_detail/movie_detail_page.dart';
import 'package:go_router/go_router.dart';

class FeatureMovieRoutes {
  FeatureMovieRoutes._();

  static const movieBrowse = '/movie-browse';
  static const movieDetail = '/movie-detail';
}

class FeatureMovieRouter {
  static final adminFeatureRoutes = [
    GoRoute(
      path: FeatureMovieRoutes.movieBrowse,
      builder: (context, state) => const MovieBrowsePage(),
    ),
    GoRoute(
      path: FeatureMovieRoutes.movieDetail,
      builder: (context, state) => MovieDetailPage(
        movieShortInfo: safeCast<Movie>(state.extra),
      ),
    ),
  ];
}
