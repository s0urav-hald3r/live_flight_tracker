import 'dart:async';
import 'package:dio/dio.dart';

class DioClient {
  late final Dio _dio;
  DioClient()
      : _dio = Dio(
          BaseOptions(
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
          ),
        );

  // GET METHOD
  Future<Response> get(String url) async {
    try {
      return await _dio.get(url);
    } catch (e) {
      rethrow;
    }
  }

  // POST METHOD
  Future<Response> post(String url, {dynamic body}) async {
    try {
      return await _dio.post(url, data: body);
    } catch (e) {
      rethrow;
    }
  }

  // PUT METHOD
  Future<Response> put(String url, {dynamic body}) async {
    try {
      return await _dio.put(url, data: body);
    } catch (e) {
      rethrow;
    }
  }

  // PATCH METHOD
  Future<Response> patch(String url, {dynamic body}) async {
    try {
      return await _dio.patch(url, data: body);
    } catch (e) {
      rethrow;
    }
  }

  // DELETE METHOD
  Future<Response> delete(String url, {dynamic body}) async {
    try {
      return await _dio.delete(url, data: body);
    } catch (e) {
      rethrow;
    }
  }
}
