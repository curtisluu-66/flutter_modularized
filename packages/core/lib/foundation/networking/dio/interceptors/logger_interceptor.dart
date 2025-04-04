part of '../dio_http_client.dart';

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String logString = "";
    try {
      logString = "🔗 REQUEST: ${options.method} - ${options.uri}"
          "\nHeader: ${options.headers}"
          "\nBody: ";

      logString = options.data is Map
          ? "$logString${json.encode(options.data ?? '')}"
          : "$logString${options.data.toString()}";
    } catch (e) {
      logString = "${logString}Can't log because exception\n$e";
    }
    AppLogger.simpleD(logString);

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.simpleD(
      "🔗 RESPONSE: ${response.requestOptions.method} - ${response.requestOptions.uri}"
      "\nStatus code: ${response.statusCode}"
      "\nResponse: ${json.encode(response.data ?? '')}",
    );

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.simpleE(
      "🔗 ERROR: ${err.requestOptions.method} - ${err.requestOptions.uri}"
      "\nError: ${err.error}"
      "\nStackTrace: ${err.stackTrace}"
      "\nResponse: ${json.encode(err.response?.data ?? '')}",
    );

    super.onError(err, handler);
  }
}
