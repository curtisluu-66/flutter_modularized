import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/constants/constants.dart';
import 'package:core/utils/logger/app_logger.dart';
import 'package:feature_movie/domain/entities/movie/movie.dart';
import 'package:feature_movie/domain/repositories/mbox_movies_repository.dart';

class MBoxMoviesRepositoryImpl implements MBoxMoviesRepository {
  @override
  Future<bool> addMovie({required Movie movie}) async {
    try {
      AppLogger.i("movie: ${movie.toJson()}");
      final db = FirebaseFirestore.instance;

      await db
          .collection(FirestoreConstants.kMovieCollectionName)
          .doc(movie.imdbID)
          .set(movie.toJson());

      return true;
    } catch (err, stacktrace) {
      AppLogger.simpleE("Add movie to database failed!", err, stacktrace);
      return false;
    }
  }

  @override
  Future<bool> removeMovie({required String imdbID}) {
    // TODO: implement removeMovieFromDatabase
    throw UnimplementedError();
  }

  @override
  Future<bool?> doesMovieExist({required String imdbID}) async {
    try {
      final db = FirebaseFirestore.instance;

      final doc = await db
          .collection(FirestoreConstants.kMovieCollectionName)
          .doc(imdbID)
          .get()
          .timeout(FirestoreConstants.fetchTimeout);

      return doc.exists;
    } catch (err, stacktrace) {
      AppLogger.simpleE("Check movie existence failed!", err, stacktrace);
      return null;
    }
  }

  @override
  Future<Movie?> getMovie({required String imdbID}) async {
    final db = FirebaseFirestore.instance;

    final doc = await db
        .collection(FirestoreConstants.kMovieCollectionName)
        .doc(imdbID)
        .get()
        .timeout(FirestoreConstants.fetchTimeout);

    return doc.exists ? Movie.fromJson(doc.data()!) : null;
  }
}
