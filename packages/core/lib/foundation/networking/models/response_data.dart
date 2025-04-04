import 'package:core/utils/formatter/safe_casting.dart';
import 'package:core/utils/logger/app_logger.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';

Future<ResponseData<T>> convertToResponseData<T>(
  Future<HttpResponse<T>> dioAction,
) async {
  HttpResponse<T>? httpResponse;

  try {
    httpResponse = await dioAction;

    return ResponseSuccess(
      data: httpResponse.data,
      originalResponse: httpResponse,
    );
  } catch (error, stackTrace) {
    AppLogger.e("Error API call!", error, stackTrace);

    return ResponseFailed(
      dioException: safeCast<DioException>(error),
      originalResponse: httpResponse,
    );
  }
}

abstract class ResponseData<T> {
  final HttpResponse<T>? originalResponse;
  final T? data;

  ResponseData({
    this.originalResponse,
    this.data,
  });
}

class ResponseSuccess<T> extends ResponseData<T> {
  ResponseSuccess({
    super.data,
    super.originalResponse,
  });
}

class ResponseFailed<T> extends ResponseData<T> {
  final DioException? dioException;
  final int? errorCode;

  ResponseFailed({
    required this.dioException,
    this.errorCode,
    super.originalResponse,
  });
}
