import 'package:feature_movie/domain/entities/movie/movie.dart';

abstract class MBoxMoviesRepository {
  /// Admin feature: save OMDB movie to firestore database, making it accessible to all users.
  /// (Like a dictator curating the only films your citizens are allowed to behold)
  ///
  /// Return the result of the operation.
  ///
  Future<bool> addMovie({
    required Movie movie,
  });

  /// Remove a movie from the database.
  ///
  /// Return the result of the operation.
  ///
  Future<bool> removeMovie({
    required String imdbID,
  });

  /// Check if the movie has already added to database.
  /// Return null if operation result is unknown.
  Future<bool?> doesMovieExist({
    required String imdbID,
  });
}
