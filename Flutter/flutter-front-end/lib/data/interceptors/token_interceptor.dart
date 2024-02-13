import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:pw5/domain/helpers/oauth_config.dart';

class TokenInterceptor extends Interceptor {
  static var log = Logger();
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if(options.baseUrl == "https://graph.microsoft.com/v1.0/"){
      final token = await OauthConfig.aadOAuth.getAccessToken();
      options.headers["Authorization"] = "Bearer $token";
      super.onRequest(options, handler);
    }
    else{
      final token = await OauthConfig.aadOAuth.getIdToken();
      options.headers["Authorization"] = "Bearer $token";
      super.onRequest(options, handler);
    }
  }
}
