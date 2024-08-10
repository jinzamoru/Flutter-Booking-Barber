// ignore_for_file: non_constant_identifier_names

import 'dart:core';

import 'package:finalprojectbarber/model/booking_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../model/appointment_model.dart';
import '../model/barber_model.dart';

import '../model/customer_model.dart';
import '../model/hair_model.dart';

class DataManagerProvider extends ChangeNotifier {
  bool isLoading = false;

  late List<BarberInfo> allBarbers;

  late List<certificateModel> allCertificate = [];
  late List<BarberBookingModel> allBarberBooking = [];
  late List<CustomerBookingModel> allCustomerBooking = [];
  late List<AllWorkScheduleModel> allWorkSchedule = [];
  late List<WorkScheduleModel> barberWorkSchedule = [];
  late List<LocationInfo> allLocation = [];
  late List<HairModel> allHair = [];
  List<certificateModel> searchListCertificate = [];

  List<BarberInfo> searchList = [];
  List<AllWorkScheduleModel> searchListWorkSchedule = [];
  List<WorkScheduleModel> searchListBarberWorkSchedule = [];
  List<HairModel> searchListhairs = [];
  late BarberInfo barberInfo;

  late CustomerInfo customerProfile = CustomerInfo(
      customerId: "",
      customerFirstName: "",
      customerLastName: "",
      customerEmail: "",
      customerPhone: "",
      customerPassword: "");

  late BarberInfo barberProfile = BarberInfo(
      barberId: '',
      barberFirstName: '',
      barberLastName: '',
      barberPhone: '',
      barberEmail: '',
      barberPassword: '',
      barberIDCard: '',
      barberNamelocation: '',
      barberLatitude: 0.0,
      barberLongitude: 0.0);

  late bool isSearching = false;

  late List<AppointmentModel> myAppointments = [];


  List<AppointmentModel> appointmentList = [];

  bool get loading => isLoading;
  List<HairModel> get getSearchListhair => searchListhairs;
  void setCustomerProfile(CustomerInfo user) {
    customerProfile = user;
    notifyListeners();
  }

  CustomerInfo get getCustomerProfile => customerProfile;

  void setBarberProfile(BarberInfo user) {
    barberProfile = user;
    notifyListeners();
  }

  BarberInfo get getBarberProfile => barberProfile;

  void setAllBarbers(List<BarberInfo> barberMapList) {
    allBarbers = barberMapList;
    notifyListeners();
  }

  void setAllCertificate(List<certificateModel> certificateMapList) {
    allCertificate = certificateMapList;
    notifyListeners();
  }

  void setAllBarberBookings(List<BarberBookingModel> bookingMapList) {
    allBarberBooking = bookingMapList;
    notifyListeners();
  }

  void setAllCustomerBookings(List<CustomerBookingModel> bookingMapList) {
    allCustomerBooking = bookingMapList;
    notifyListeners();
  }

  void setAllWorkSchedule(List<AllWorkScheduleModel> workScheduleMapList) {
    allWorkSchedule = workScheduleMapList;
    notifyListeners();
  }

  void setBarberWorkSchedule(List<WorkScheduleModel> workScheduleMapList) {
    barberWorkSchedule = workScheduleMapList;
    notifyListeners();
  }

  void setAllLocation(List<LocationInfo> locationMapList) {
    allLocation = locationMapList;
    notifyListeners();
  }

  void setAllHairs(List<HairModel> hairMapList) {
    allHair = hairMapList;
    notifyListeners();
  }

  List<AllWorkScheduleModel> get getAllWorkSchedule => allWorkSchedule;
  List<WorkScheduleModel> get getBarberWorkSchedule => barberWorkSchedule;
  List<BarberBookingModel> get getAllBarberBooking => allBarberBooking;
  List<CustomerBookingModel> get getAllCustomerBooking => allCustomerBooking;
  List<LocationInfo> get getAllLocation => allLocation;
  List<certificateModel> get getAllCertificate => allCertificate;

  List<HairModel> get getAllHairs => allHair;

  List<BarberInfo> get getAllBarbers => allBarbers;

  List<AllWorkScheduleModel> get getSearchList => searchListWorkSchedule;

  void getSearchHair(String searchKey) {
    for (var element in allHair) {
      if (element.hairName.toLowerCase().startsWith(searchKey.toLowerCase()) ||
          element.hairName.startsWith(searchKey.toLowerCase())) {
        searchResultHair(element);
      }
    }
  }

  void searchResultHair(HairModel hairModel) {
    searchListhairs.add(hairModel);
    notifyListeners();
  }

  void getSearch(String searchKey) {
    for (var element in allWorkSchedule) {
      if (element.barber.barberFirstName
              .toLowerCase()
              .startsWith(searchKey.toLowerCase()) ||
          element.barber.barberFirstName.startsWith(searchKey.toLowerCase())) {
        searchResult(element);
      }
    }
  }

  void getSearchBarberWorkSchedule(String searchKey) {
    final DateFormat formatter =
        DateFormat('d MMMM', 'th'); // 'th' is for Thai locale
    for (var element in barberWorkSchedule) {
      String formattedDate =
          formatter.format(element.workSchedule.workScheduleStartDate);
      if (formattedDate.toLowerCase().startsWith(searchKey.toLowerCase()) ||
          element.barber.barberFirstName
              .toLowerCase()
              .startsWith(searchKey.toLowerCase())) {
        searchResultBarberWorkSchedule(element);
      }
    }
  }

  void searchResultBarberWorkSchedule(WorkScheduleModel Model) {
    searchListBarberWorkSchedule.add(Model);
    notifyListeners();
  }

  void searchResult(AllWorkScheduleModel Model) {
    searchListWorkSchedule.add(Model);
    notifyListeners();
  }

  List<AllWorkScheduleModel> get getSearchListWorkSchedule =>
      searchListWorkSchedule;
  List<WorkScheduleModel> get getSearchListBarberWorkSchedule =>
      searchListBarberWorkSchedule;

  void setIsSearching(bool value) {
    isSearching = value;
    notifyListeners();
  }

  bool get searchingStart => isSearching;

  void getSearchBarber(String searchKey) {
    for (var element in allCertificate) {
      if (element.certificatesPhoto
              .toLowerCase()
              .startsWith(searchKey.toLowerCase()) ||
          element.certificatesPhoto.startsWith(searchKey.toLowerCase())) {
        searchResultBarber(element);
      }
    }
  }

  void searchResultBarber(certificateModel certificate) {
    searchListCertificate.add(certificate);
    notifyListeners();
  }
  // void setBarberBasicInformation(
  //     String id, String name, String email, String contact) {
  //   barberInfo = BarberInfo(
  //       barberId: id,
  //       barberFullName: name,
  //       barberEmail: email,
  //       barberContact: contact,
  //       roll: 'Barber',
  //       barberPassword: '');
  //   notifyListeners();
  // }

  // void setBarberShopInfo(
  //     String shopName,
  //     String seats,
  //     String description,
  //     String address,
  //     double latitude,
  //     double longitude,
  //     String startTime,
  //     String endTime) {
  //   Location location =
  //       Location(address: address, latitude: latitude, longitude: longitude);
  //   ShopStatus status =
  //       ShopStatus(status: 'Open', startTime: startTime, endTime: endTime);
  //   final _random = Random();
  //   String index = urls[_random.nextInt(urls.length)];
  //   barberCompleteData = BarberModel(
  //       shopName: shopName,
  //       barber: barberInfo,
  //       seats: seats,
  //       description: description,
  //       rating: 0.0,
  //       goodReviews: 0,
  //       totalScore: 0,
  //       satisfaction: 0,
  //       image: index,
  //       location: location,
  //       shopStatus: status,
  //      );
  //   notifyListeners();
  // }

  // BarberModel get getBarberDetails => barberCompleteData;

/////////////////appointment
  void setAppointmentList(List<AppointmentModel> model) {
    appointmentList = model;
    notifyListeners();
  }

  void setMyAppointments(List<AppointmentModel> model) {
    myAppointments = model;
    notifyListeners();
  }

  // void setMyAppointmentWithBarber(BarberModel barberModel) {
  //   myAppointmentWithBarber = barberModel;
  //   notifyListeners();
  // }
}
