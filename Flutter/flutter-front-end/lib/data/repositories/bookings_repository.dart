import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:pw5/data/clients/auth_client.dart';
import 'package:pw5/domain/exceptions/exceptions.dart';
import 'package:pw5/domain/models/booking_model.dart';
import 'package:pw5/domain/models/filters_model.dart';

class BookingsRepository {
  static var log = Logger();

  Future<List<Booking>> getMyFirstFourBookings() async {
    try {
      final response = await AuthClient.dio.get("/api/Reservation/GetSelfTop4");
      final List<dynamic> resultList = response.data as List<dynamic>;

      final List<Booking> bookings = resultList.map((bookingMap) {
        return Booking.fromJson(bookingMap as Map<String, dynamic>);
      }).toList();
      return bookings;
    } on DioException catch (e) {
      log.d("first four bookings -- dioexception ${e.message}");
      rethrow;
    } catch (e) {
      log.d("first four bookings -- generic ${e.toString()}");
      throw GenericError(message: e.toString());
    }
  }

  Future<List<Booking>> getMyBookings() async {
    try {
      final response = await AuthClient.dio.get("/api/Reservation/GetUserSelf");
      final List<dynamic> resultList = response.data as List<dynamic>;

      final List<Booking> bookings = resultList.map((bookingMap) {
        return Booking.fromJson(bookingMap as Map<String, dynamic>);
      }).toList();

      return bookings;
    } on DioException catch (e) {
      log.d("my bookings -- dioexception ${e.message}");
      rethrow;
    } catch (e) {
      log.d("my bookings -- generic ${e.toString()}");
      throw GenericError(message: e.toString());
    }
  }

  Future<List<Booking>> getMyBookingsWithFilters(Filters filters) async {
    try {
      final response = await AuthClient.dio.post(
        "/api/Reservation/GetSelfFilter",
        data: filters.toJson(),
      );
      final List<dynamic> resultList = response.data as List<dynamic>;

      final List<Booking> bookings = resultList.map((bookingMap) {
        return Booking.fromJson(bookingMap as Map<String, dynamic>);
      }).toList();

      return bookings;
    } on DioException catch (e) {
      log.d("my bookings filtered -- dioexception ${e.message}");
      rethrow;
    } catch (e) {
      log.d("my bookings filtered -- generic ${e.toString()}");
      throw GenericError(message: e.toString());
    }
  }
}
