import 'dart:developer';

import 'package:dio/dio.dart';

/// This interceptor is used to show request and response logs
class LoggerInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log("Dio Error message: ${err.type}");

    // Check for server connection issues
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      log("Server Error: The server is not reachable.");
    } else if (err.type == DioExceptionType.unknown) {
      log("Server Error: Unable to connect to the server.");
    } else {
      log("Dio Error message: ${err.message}");
    }

    if (err.response != null) {
      log('Status Code: ${err.response?.statusCode}');
      log('Response Data: ${err.response?.data}');
    }

    handler.next(err); //Continue with the Error
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requestPath = '${options.baseUrl}${options.path}';
    log('${options.method} request ==> $requestPath'); //Info log
    if (options.method != 'GET') {
      log('Request body ==> ${options.data}'); //Info log
    }

    handler.next(options); // continue with the Request
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('Status Code: ${response.statusCode}\n'
        'Status Message: ${response.statusMessage}\n'
        'Data: ${response.data}'); // Debug log

    handler.next(response); // continue with the Response
  }
}
