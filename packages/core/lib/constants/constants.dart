import 'dart:async';
import 'dart:io';
import 'package:package_info_plus/package_info_plus.dart';

final kAdminAppPackageName =
    Platform.isIOS ? "vn.hongduc.adminApp" : "vn.hongduc.admin_app";

bool? _kIsAdminApp;

FutureOr<bool> get kIsAdminApp async {
  try {
    if (_kIsAdminApp == null) {
      final packageInfo = await PackageInfo.fromPlatform();
      _kIsAdminApp = packageInfo.packageName == kAdminAppPackageName;
    }

    return _kIsAdminApp!;
  } catch (_) {
    return false;
  }
}

// Firestore database names
class FirestoreConstants {
  FirestoreConstants._();
  static const kUserCollectionName = "user";
  static const kMovieCollectionName = "movie";
  static const kUserFavoritesCollectionName = "user_favorites";

  static const fetchTimeout = Duration(seconds: 5);
}
