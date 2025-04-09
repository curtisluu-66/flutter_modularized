import 'package:feature_movie/data/datasource_providers.dart';
import 'package:feature_movie/data/repositories/mbox_movies_repository_impl.dart';
import 'package:feature_movie/data/repositories/movie_repository_impl.dart';
import 'package:feature_movie/domain/repositories/mbox_movies_repository.dart';
import 'package:feature_movie/domain/repositories/movie_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository_providers.g.dart';

@riverpod
MBoxMoviesRepository mBoxMoviesRepository(Ref ref) {
  return MBoxMoviesRepositoryImpl();
}

@riverpod
Future<MovieRepository> movieRepository(Ref ref) async {
  return MovieRepositoryImpl(
    movieApi: await ref.watch(movieApiProvider.future),
  );
}
