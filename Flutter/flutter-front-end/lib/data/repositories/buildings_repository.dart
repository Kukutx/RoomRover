import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:pw5/data/clients/auth_client.dart';
import 'package:pw5/domain/exceptions/exceptions.dart';
import 'package:pw5/domain/models/building_model.dart';

class BuildingsRepository {

  static var log = Logger();

  Future<List<Building>> getMyBuildings() async {
    try {
      final response = await AuthClient.dio.get(
        "/api/building/getall"
      );
      final List<Building> result = List.from(response.data)
        .map((buildingMap) => Building.fromJson(buildingMap))
        .toList();
      return result;
    } on DioException catch (e) {
      log.d("buildings -- dioexception ${e.message}");
      rethrow;
    }
    catch (e) {
      log.d("buildings -- generic ${e.toString()}");
      throw GenericError(message:e.toString());
    }
  }

  Future<Building> getById(int id) async {
    try {
      final response = await AuthClient.dio.get("/api/Building/GetById/$id");
      final Building result = Building.fromJson(response.data);
      return result;
    } on DioException catch (e) {
      log.d("my resource -- dioexception ${e.message}");
      rethrow;
    } catch (e) {
      log.d("my resource -- generic ${e.toString()}");
      throw GenericError(message: e.toString());
    }
  }
}
