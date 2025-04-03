import 'dart:convert';

import 'package:core/utils/logger/app_logger.dart';

T? safeCast<T>(dynamic object) {
  if (object is! T) {
    AppLogger.w(
      "safeCast error - Try to cast object from ${object.runtimeType} to $T",
    );
  }

  return object is T ? object : null;
}

Map<String, dynamic> safeToJson(object) {
  if (object == null) return {};

  try {
    try {
      return object.toMap();
    } catch (e) {
      try {
        return object.toJson();
      } catch (e) {
        final dataJsonStr = jsonEncode(object);
        final dataJson = jsonDecode(dataJsonStr);

        return Map<String, dynamic>.from(dataJson);
      }
    }
  } catch (e) {
    AppLogger.e(e);

    return {};
  }
}
