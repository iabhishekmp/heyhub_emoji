import 'package:dio/dio.dart';

class AppDio {
  AppDio._();
  static final _dio = _getDio();
  static Dio _getDio() {
    return Dio()..interceptors.add(LogInterceptor());
  }

  static Dio get instance => _dio;
}
