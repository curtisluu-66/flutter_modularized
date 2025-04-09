const kAdminAppPackageName = "vn.hongduc.admin_app";

// Firestore database names
class FirestoreConstants {
  FirestoreConstants._();
  static const kUserCollectionName = "user";
  static const kMovieCollectionName = "movie";
  static const kUserFavoritesCollectionName = "user_favorites";

  static const fetchTimeout = Duration(seconds: 5);
}
