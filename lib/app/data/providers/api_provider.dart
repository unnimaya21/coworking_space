import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import '../../core/constants/api_constants.dart';
import '../../core/utils/storage_keys.dart';

class ApiProvider {
  late Dio _dio;
  final GetStorage _storage = GetStorage();

  ApiProvider() {
    final token = _storage.read(StorageKeys.authToken);
    log('API Request:  $token');
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          ApiConstants.contentTypeHeader: ApiConstants.applicationJson,
          ApiConstants.acceptHeader: ApiConstants.applicationJson,
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _storage.read(StorageKeys.authToken);
          log('API Request: ${options.method} ${options.path} $token');
          if (token != null) {
            options.headers.addAll({
              "Authorization": 'Bearer $token',
              "Accept": "*/*",
            });
            // options.headers[ApiConstants.authorizationHeader] =
            //     '${ApiConstants.bearerPrefix}$token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          log('API Error: ${error.message}');
          handler.next(error);
        },
      ),
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } catch (e) {
      rethrow;
    }
  }
}
