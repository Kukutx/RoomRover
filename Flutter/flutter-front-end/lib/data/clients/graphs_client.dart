import 'package:dio/dio.dart';
import 'package:pw5/data/interceptors/token_interceptor.dart';

class GraphsClient {
  static final options = BaseOptions(
    baseUrl: "https://graph.microsoft.com/v1.0/",
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

class GraphsClientImage {
  static final options = BaseOptions(
    baseUrl: "https://graph.microsoft.com/v1.0/",
    responseType: ResponseType.bytes,
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