import 'package:dio/dio.dart';
import 'package:pw5/data/interceptors/token_interceptor.dart';

class AuthClient {
  static final options = BaseOptions(
    baseUrl: "https://roomroverbedev.azurewebsites.net",
    contentType: "application/json; charset=UTF-8",
  );

  static Dio get dio {
    final Dio dio = Dio(options);
    dio.interceptors.addAll([
      TokenInterceptor(),
      LogInterceptor(requestBody: true, responseBody: true),
    ]);
    return dio;
  }
}
