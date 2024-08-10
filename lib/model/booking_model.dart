import 'package:finalprojectbarber/model/customer_model.dart';

import 'barber_model.dart';
import 'hair_model.dart';

class BarberBookingModel {
  BookingInfo booking;
  LocationInfo location;
  CustomerInfo customer;
  HairModel hair;
  DateTime workScheduleStartDate;
  DateTime workScheduleEndDate;

  BarberBookingModel(
      {required this.booking,
      required this.location,
      required this.customer,
      required this.hair,
      required this.workScheduleStartDate,
      required this.workScheduleEndDate});
}

class CustomerBookingModel {
  BookingInfo booking;
  LocationInfo location;
  BarberInfo barber;
  HairModel hair;
  DateTime workScheduleStartDate;
  DateTime workScheduleEndDate;

  CustomerBookingModel(
      {required this.booking,
      required this.location,
      required this.hair,
      required this.barber,
      required this.workScheduleStartDate,
      required this.workScheduleEndDate});
}

class BookingInfo {
  final String bookingId;
  final String customerId;
  final String locationId;
  final String barberId;
  final DateTime startTime;
  final DateTime endTime;
  final int bookingStatus;
  final String hairId;
  final String workScheduleId;
  final int bookingPrice;

  const BookingInfo({
    required this.bookingId,
    required this.locationId,
    required this.customerId,
    required this.barberId,
    required this.bookingStatus,
    required this.hairId,
    required this.startTime,
    required this.endTime,
    required this.workScheduleId,
    required this.bookingPrice,
  });
}
