import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:pw5/data/clients/auth_client.dart';
import 'package:pw5/domain/exceptions/exceptions.dart';
import 'package:pw5/domain/models/building_model.dart';
import 'package:pw5/domain/models/new_reservation_model.dart';
import 'package:pw5/domain/models/reservation_time_range_model.dart';
import 'package:pw5/domain/models/resource_model.dart';

class ResourceRepository {
  static var log = Logger();

  Future<List<ResourceModel>> getMyResource() async {
    try {
      final response = await AuthClient.dio.get("/api/resource/getall");
      final List<ResourceModel> result = List.from(response.data)
          .map((resourceMap) => ResourceModel.fromJson(resourceMap))
          .toList();
      return result;
    } on DioException catch (e) {
      log.d("my resource -- dioexception ${e.message}");
      rethrow;
    } catch (e) {
      log.d("my resource -- generic ${e.toString()}");
      throw GenericError(message: e.toString());
    }
  }

  Future<List<ResourceModel>> getMyFreeResource(
      ReservationTimeRange reservationTimeRange) async {
    try {
      final response = await AuthClient.dio.post(
        "/api/Resource/GetFreeResource",
        data: reservationTimeRange.toJson(),
      );
      final List<ResourceModel> result = List.from(response.data)
          .map((resourceMap) => ResourceModel.fromJson(resourceMap))
          .toList();
      return result;
    } on DioException catch (e) {
      log.d("my reeResource -- dioexception ${e.message}");
      rethrow;
    } catch (e) {
      log.d("my reeResource -- generic ${e.toString()}");
      throw GenericError(message: e.toString());
    }
  }

  Future<List<ResourceModel>> getResourceFromRangeDate(
      ReservationTimeRange reservationTimeRange) async {
    try {
      final response = await AuthClient.dio.post(
        "/api/Resource/GetResourceFromRangeDate",
        data: reservationTimeRange.toJson(),
      );
      final List<ResourceModel> result = List.from(response.data)
          .map((resourceMap) => ResourceModel.fromJson(resourceMap))
          .toList();
      return result;
    } on DioException catch (e) {
      log.d("my Resource -- dioexception ${e.message}");
      rethrow;
    } catch (e) {
      log.d("my Resource -- generic ${e.toString()}");
      throw GenericError(message: e.toString());
    }
  }

  Future<void> createMyReservation(NewReservation reservation) async {
    try {
      await AuthClient.dio.post(
        "/api/Reservation/Create",
        data: reservation.toJson(),
      );
    } on DioException catch (e) {
      log.d("my Resource -- dioexception ${e.message}");
      rethrow;
    } catch (e) {
      log.d("my Resource -- generic ${e.toString()}");
      throw GenericError(message: e.toString());
    }
  }

  Future<void> deleteMyReservation(int id) async {
    try {
      await AuthClient.dio.delete("/api/Reservation/Delete/$id");
    } on DioException catch (e) {
      log.d("my Reservation -- dioexception ${e.message}");
      rethrow;
    } catch (e) {
      log.d("my Reservation -- generic ${e.toString()}");
      throw GenericError(message: e.toString());
    }
  }

  Future<Building> getByReservationId(int id) async {
    try {
      final response =
          await AuthClient.dio.get("/api/Building/GetByReservationId/$id");
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

  Future<List<ResourceModel>> getById(int id) async {
    try {
      final response = await AuthClient.dio.get("/api/Resource/GetById/$id");
      final ResourceModel result = ResourceModel.fromJson(response.data);
      return [result];
    } on DioException catch (e) {
      log.d("my resource -- dioexception ${e.message}");
      rethrow;
    } catch (e) {
      log.d("my resource -- generic ${e.toString()}");
      throw GenericError(message: e.toString());
    }
  }
}
