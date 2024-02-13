// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pw5/data/clients/auth_client.dart';
import 'package:pw5/data/clients/graphs_client.dart';
import 'package:pw5/domain/exceptions/exceptions.dart';
import 'package:pw5/domain/helpers/oauth_config.dart';
import 'package:pw5/domain/models/link_immagine_model.dart';
import 'package:pw5/domain/models/user_model.dart';
import 'package:pw5/ui/pages/login/login_screen.dart';

class AuthRepository {

  static var log = Logger();

  Future<void> azureLogin() async {
    try {
      final result = await OauthConfig.aadOAuth.login();
      result.fold(
        (failure) => throw Exception(failure.message),
        (token) => log.i(
          'Logged in successfully, your access token: ${token.accessToken}',
        ),
      );
    } catch (e) {
      log.e(e);
      rethrow;
    }
  }

  Future<void> azureLogout(BuildContext context) async {
    await OauthConfig.aadOAuth.logout();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
    //Navigator.popUntil(context, (route) => route.isFirst);
    
  }

  Future<User> getProfile() async {
    try {
      final response = await GraphsClient.dio.get(
        "/me"
      );
      final result = User.fromJson(response.data);
      return result;
    } on DioException catch (e) {
      log.d("profile -- dioexception ${e.message}");
      rethrow;
    }
    catch (e) {
      log.d("profile -- generic ${e.toString()}");
      throw GenericError(message:e.toString());
    }
  }

  Future<void> postUserToDb() async {
    try {
      await AuthClient.dio.post(
        "/api/User/Create"
      );
    } on DioException catch (e) {
      log.d("user create -- dioexception ${e.message}");
      rethrow;
    }
    catch (e) {
      log.d("user create -- generic ${e.toString()}");
      throw GenericError(message:e.toString());
    }
  }

  Future<Uint8List> getImmagine() async {
    try {
      final response = await GraphsClientImage.dio.get(
        "/me/photo/\$value",
      );
      return response.data ?? Uint8List(0);
    } on DioException catch (e) {
      log.d("immagine -- dioexception ${e.message}");
      rethrow;
    }
    catch (e) {
      log.d("immagine -- generic ${e.toString()}");
      throw GenericError(message:e.toString());
    }
  }

  Future<List<UserGetAll>> getAllUsers() async {
    try {
      final response = await AuthClient.dio.get("/api/User/GetAll");
      final List<dynamic> resultList = response.data as List<dynamic>;

      final List<UserGetAll> emails = resultList.map((emailMap) {
        return UserGetAll.fromJson(emailMap as Map<String, dynamic>);
      }).toList();

      return emails;
    } on DioException catch (e) {
      log.d("all emails -- dioexception ${e.message}");
      rethrow;
    } catch (e) {
      log.d("all emails -- generic ${e.toString()}");
      throw GenericError(message: e.toString());
    }
  }
}
