import 'dart:async';

import 'package:core/utils/logger/app_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension CacheForExtension on Ref {
  void cacheFor(Duration duration) {
    // Immediately prevent the state from getting destroyed.
    final link = keepAlive();

    // After duration has elapsed, we re-enable automatic disposal.
    final timer = Timer(duration, () {
      link.close(); // release keepAlive
    });

    // Optional: when the provider is recomputed (such as with ref.watch),
    // we cancel the pending timer.
    onDispose(() {
      AppLogger.i("[$runtimeType] Cache result has been invalidated!");
      timer.cancel();
    });
  }
}
