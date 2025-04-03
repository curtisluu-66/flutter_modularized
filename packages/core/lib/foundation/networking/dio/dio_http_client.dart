import 'dart:convert';

import 'package:core/utils/logger/app_logger.dart';
import 'package:dio/dio.dart';

part 'interceptors/logger_interceptor.dart';

class DioHttpClient with DioMixin implements Dio {
  DioHttpClient({
    required String baseUrl,
  }) {
    options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
    );

    options.headers.addAll({
      "Content-Type": "application/json",
    });

    httpClientAdapter = HttpClientAdapter();

    interceptors.add(LoggerInterceptor());
  }
}
