// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:finalprojectbarber/barber_homepage.dart';
import 'package:finalprojectbarber/login.dart';
import 'package:finalprojectbarber/model/booking_model.dart';
import 'package:finalprojectbarber/model/payment_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../customer_homepage.dart';
import '../data_manager/data_manager.dart';
import '../model/barber_model.dart';
import '../model/customer_model.dart';
import 'dart:convert';

import '../model/hair_model.dart';

const server = "https://c464-2001-fb1-11d-c5f-d975-3ffa-afb3-7087.ngrok-free.app/BBapi";

Future<void> addCustomerProfileData(
    CustomerInfo user, BuildContext context) async {
  try {
    const url = '$server/add_customer.php';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'firstname': user.customerFirstName,
        'lastname': user.customerLastName,
        'email': user.customerEmail,
        'phone': user.customerPhone,
        'password': user.customerPassword,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('แจ้งเตือน'),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ),
                  ),
                  child: const Text('ตกลง'),
                ),
              ],
            );
          },
        );
      } else {
        showErrorDialog(data['message'], context);
      }
    }
  } catch (e) {
    showErrorDialog('$e', context);
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
  }
}

Future<bool> loginUser(
    String email, String password, String roll, BuildContext context) async {
  try {
    const url = "$server/login.php";
    final response = await http.post(
      Uri.parse(url),
      body: {'email': email, 'password': password, 'roll': roll},
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        if (roll == 'Customer') {
          if (await getCustomerProfile(email, context)) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => const CustomerHomePage()),
                (Route<dynamic> route) => false);
          }
        } else {
          if (await getBarberProfile(email, context)) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const BarberHomePage()),
                (Route<dynamic> route) => false);
          }
        }
        return true;
      } else {
        showErrorDialog(data['message'], context);
        return false;
      }
    } else {
      showErrorDialog('เชื่อมต่อกับเซิร์ฟเวอร์ล้มเหลว', context);
      return false;
    }
  } catch (e) {
    showErrorDialog('$e', context);
    return false;
  }
}

Future<bool> getCustomerProfile(email, BuildContext context) async {
  try {
    final url = Uri.parse('$server/get_customer.php?email=$email');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        final Map<String, dynamic> userData = data['data'];
        String id = userData['id'].toString();
        String name = userData['name'].toString();
        String lastname = userData['lastname'].toString();
        String email = userData['email'].toString();
        String phone = userData['phone'].toString();
        final cusData = CustomerInfo(
          customerId: id,
          customerFirstName: name,
          customerLastName: lastname,
          customerEmail: email,
          customerPhone: phone,
          customerPassword: '',
        );
        Provider.of<DataManagerProvider>(context, listen: false)
            .setCustomerProfile(cusData);
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    return false;
  }
}

Future<bool> getBarberProfile(email, BuildContext context) async {
  try {
    final url = Uri.parse('$server/get_barber.php?email=$email');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        final Map<String, dynamic> userData = data['data'];
        String id = userData['id'].toString();
        String name = userData['name'].toString();
        String lastname = userData['lastname'].toString();
        String phone = userData['phone'].toString();
        String email = userData['email'].toString();
        String idcard = userData['idcard'].toString();
        String namelocation = userData['namelocation'].toString();
        double latitude = userData['latitude'];
        double longitude = userData['longitude'];
        BarberInfo barberData = BarberInfo(
            barberId: id,
            barberFirstName: name,
            barberLastName: lastname,
            barberPhone: phone,
            barberEmail: email,
            barberPassword: "",
            barberIDCard: idcard,
            barberNamelocation: namelocation,
            barberLatitude: latitude,
            barberLongitude: longitude);
        Provider.of<DataManagerProvider>(context, listen: false)
            .setBarberProfile(barberData);
        return true;
      } else {
        showErrorDialog(data['message'], context);
        return false;
      }
    } else {
      showErrorDialog('เชื่อมต่อกับเซิร์ฟเวอร์ล้มเหลว', context);
      return false;
    }
  } catch (e) {
    showErrorDialog('$e', context);
    return false;
  }
}

Future<void> getCertificates(String id, BuildContext context) async {
  List<certificateModel> certificateList = [];
  try {
    final url = Uri.parse('$server/get_all_certificate.php/?id=$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        var certificateData = data['data'];
        if (certificateData is List) {
          for (var certificate in certificateData) {
            certificateList.add(certificateModel(
              certificatesId: certificate['id'].toString(),
              certificatesPhoto: certificate['photo'].toString(),
              certificatesBarberID: certificate['ba_id'].toString(),
            ));
          }
        }

        Provider.of<DataManagerProvider>(context, listen: false)
            .setAllCertificate(certificateList);
      } else {
        Provider.of<DataManagerProvider>(context, listen: false)
            .setAllCertificate([]);
      }
    } else {
      Provider.of<DataManagerProvider>(context, listen: false)
          .setAllCertificate([]);
    }
  } catch (e) {
    showErrorDialog('$e', context);
    Provider.of<DataManagerProvider>(context, listen: false)
        .setAllCertificate([]);
  }
}

Future<void> getBarberBooking(String id, BuildContext context) async {
  List<BarberBookingModel> bookingList = [];
  try {
    final url = Uri.parse('$server/get_barber_booking.php/?id=$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        var bookingData = data['data'];
        if (bookingData is List) {
          for (var booking in bookingData) {
            bookingList.add(BarberBookingModel(
              booking: BookingInfo(
                bookingId: booking['bk_id'].toString(),
                customerId: booking['cus_id'].toString(),
                bookingPrice: booking['price'] as int,
                bookingStatus: booking['status'] as int,
                workScheduleId: booking['ws_id'].toString(),
                locationId: booking['lo_id'].toString(),
                hairId: booking['hair_id'].toString(),
                startTime: DateTime.parse(booking['bk_startdate']),
                endTime: DateTime.parse(booking['bk_enddate']),
                barberId: booking['ba_id'].toString(),
              ),
              location: LocationInfo(
                  locationCusId: booking['cus_id'].toString(),
                  locationId: booking['lo_id'].toString(),
                  locationLatitude: booking['latitude'] as double,
                  locationLongitude: booking['longitude'] as double,
                  locationName: booking['namelocation'].toString()),
              customer: CustomerInfo(
                  customerId: booking['cus_id'].toString(),
                  customerFirstName: booking['name'].toString(),
                  customerLastName: booking['lastname'].toString(),
                  customerEmail: "",
                  customerPhone: booking['phone'].toString(),
                  customerPassword: ''),
              hair: HairModel(
                hairId: booking['hair_id'].toString(),
                hairName: booking['hair_name'].toString(),
                hairPrice: booking['hair_price'] as int,
                hairPhoto: booking['hair_photo'].toString(),
                barberId: booking['barber_id'].toString(),
              ),
              workScheduleStartDate: DateTime.parse(booking['ws_startdate']),
              workScheduleEndDate: DateTime.parse(booking['ws_enddate']),
            ));
          }
        }
        Provider.of<DataManagerProvider>(context, listen: false)
            .setAllBarberBookings(bookingList);
      } else {
        Provider.of<DataManagerProvider>(context, listen: false)
            .setAllBarberBookings([]);
      }
    }
  } catch (e) {
    Provider.of<DataManagerProvider>(context, listen: false)
        .setAllBarberBookings([]);
    showErrorDialog('$e', context);
  }
}

Future<void> getCustomerBooking(String id, BuildContext context) async {
  List<CustomerBookingModel> bookingList = [];
  try {
    final url = Uri.parse('$server/get_customer_booking.php/?id=$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        var bookingData = data['data'];
        if (bookingData is List) {
          for (var booking in bookingData) {
            bookingList.add(CustomerBookingModel(
              booking: BookingInfo(
                bookingId: booking['bk_id'].toString(),
                customerId: booking['cus_id'].toString(),
                bookingPrice: booking['price'] as int,
                bookingStatus: booking['status'] as int,
                workScheduleId: booking['ws_id'].toString(),
                locationId: booking['lo_id'].toString(),
                hairId: booking['hair_id'].toString(),
                startTime: DateTime.parse(booking['bk_startdate']),
                endTime: DateTime.parse(booking['bk_enddate']),
                barberId: booking['barber_id'].toString(),
              ),
              location: LocationInfo(
                  locationCusId: booking['cus_id'].toString(),
                  locationId: booking['lo_id'].toString(),
                  locationLatitude: booking['latitude'] as double,
                  locationLongitude: booking['longitude'] as double,
                  locationName: booking['namelocation'].toString()),
              barber: BarberInfo(
                barberId: booking['ba_id'].toString(),
                barberFirstName: booking['ba_name'].toString(),
                barberLastName: booking['ba_lastname'].toString(),
                barberPhone: booking['ba_phone'].toString(),
                barberEmail: '',
                barberPassword: '',
                barberIDCard: '',
                barberNamelocation: booking['ba_namelocation'].toString(),
                barberLatitude: booking['ba_latitude'] as double,
                barberLongitude: booking['ba_longitude'] as double,
              ),
              hair: HairModel(
                  hairId: booking['hair_id'].toString(),
                  hairName: booking['hair_name'].toString(),
                  hairPrice: booking['hair_price'] as int,
                  hairPhoto: "",
                  barberId: booking['ba_id'].toString()),
              workScheduleStartDate: DateTime.parse(booking['ws_startdate']),
              workScheduleEndDate: DateTime.parse(booking['ws_enddate']),
            ));
          }
        }
        Provider.of<DataManagerProvider>(context, listen: false)
            .setAllCustomerBookings(bookingList);
      } else {
        Provider.of<DataManagerProvider>(context, listen: false)
            .setAllCustomerBookings([]);
        // showErrorDialog(data['message'], context);
      }
    } else {
      Provider.of<DataManagerProvider>(context, listen: false)
          .setAllCustomerBookings([]);
    }
  } catch (e) {
    Provider.of<DataManagerProvider>(context, listen: false)
        .setAllCustomerBookings([]);
    showErrorDialog('$e', context);
  }
}

Future<void> getHairs(String id, BuildContext context) async {
  List<HairModel> hairList = [];
  try {
    final url = Uri.parse('$server/get_hair.php/?id=$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        var hairData = data['data'];
        if (hairData is List) {
          for (var hair in hairData) {
            hairList.add(HairModel(
              hairId: hair['id'].toString(),
              hairName: hair['name'].toString(),
              hairPrice: hair['price'].toInt(),
              hairPhoto: hair['photo'].toString(),
              barberId: hair['ba_id'].toString(),
            ));
          }
        }
        Provider.of<DataManagerProvider>(context, listen: false)
            .setAllHairs(hairList);
      } else {
        Provider.of<DataManagerProvider>(context, listen: false)
            .setAllHairs([]);
      }
    } else {
      Provider.of<DataManagerProvider>(context, listen: false).setAllHairs([]);
    }
  } catch (e) {
    showErrorDialog('$e', context);
  }
}

Future<void> getAllHairs(BuildContext context) async {
  List<HairModel> hairList = [];
  try {
    final url = Uri.parse('$server/get_hair.php');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        var hairData = data['data'];
        if (hairData is List) {
          for (var hair in hairData) {
            hairList.add(HairModel(
              hairId: hair['id'].toString(),
              hairName: hair['name'].toString(),
              hairPrice: hair['price'].toInt(),
              hairPhoto: hair['photo'].toString(),
              barberId: hair['ba_id'].toString(),
            ));
          }
        }
        Provider.of<DataManagerProvider>(context, listen: false)
            .setAllHairs(hairList);
      } else {
        Provider.of<DataManagerProvider>(context, listen: false)
            .setAllHairs([]);
      }
    } else {
      Provider.of<DataManagerProvider>(context, listen: false).setAllHairs([]);
    }
  } catch (e) {
    // showErrorDialog('$e', context);
  }
}

Future<void> getAllWorkSchedule(BuildContext context) async {
  List<AllWorkScheduleModel> workScheduleList = [];
  try {
    final url = Uri.parse('$server/get_all_workSchedule.php');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        var workScheduleData = data['data'];
        if (workScheduleData is List) {
          for (var work in workScheduleData) {
            workScheduleList.add(AllWorkScheduleModel(
              barber: BarberInfo(
                  barberId: work['ba_id'].toString(),
                  barberFirstName: work['name'].toString(),
                  barberLastName: work['lastname'].toString(),
                  barberEmail: work['email'].toString(),
                  barberPhone: work['phone'].toString(),
                  barberIDCard: work['idcard'].toString(),
                  barberNamelocation: work['namelocation'].toString(),
                  barberLatitude: work['latitude'] as double,
                  barberLongitude: work['longitude'] as double,
                  barberPassword: ""),
              workSchedule: WorkSchedule(
                workScheduleID: work['ws_id'].toString(),
                workScheduleStartDate: DateTime.parse(work['startdate']),
                workScheduleEndDate: DateTime.parse(work['enddate']),
                workScheduleNote: work['note'].toString(),
                workScheduleBarberID: work['ba_id'].toString(),
                workScheduleStatus: work['status'] as int,
              ),
              total: work['total'] as int,
            ));
          }
        }
        Provider.of<DataManagerProvider>(context, listen: false)
            .setAllWorkSchedule(workScheduleList);
      } else {
        Provider.of<DataManagerProvider>(context, listen: false)
            .setAllWorkSchedule([]);
      }
      // showErrorDialog(data['message'], context);
    } else {
      showErrorDialog('ไม่สามารถติดต่อเซิร์ฟเวอร์ได้', context);
      Provider.of<DataManagerProvider>(context, listen: false)
          .setAllWorkSchedule([]);
    }
  } catch (e) {
    Provider.of<DataManagerProvider>(context, listen: false)
        .setAllWorkSchedule([]);
    showErrorDialog('$e', context);
  }
}

Future<void> getWorkSchedule(String id, BuildContext context) async {
  List<WorkScheduleModel> workScheduleList = [];
  try {
    final url = Uri.parse('$server/get_barber_workSchedule.php/?id=$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        var workScheduleData = data['data'];
        if (workScheduleData is List) {
          for (var work in workScheduleData) {
            workScheduleList.add(WorkScheduleModel(
              barber: BarberInfo(
                  barberId: work['ba_id'].toString(),
                  barberFirstName: work['name'].toString(),
                  barberLastName: work['lastname'].toString(),
                  barberEmail: work['email'].toString(),
                  barberPhone: work['phone'].toString(),
                  barberIDCard: work['idcard'].toString(),
                  barberNamelocation: work['namelocation'].toString(),
                  barberLatitude: work['latitude'] as double,
                  barberLongitude: work['longitude'] as double,
                  barberPassword: ""),
              workSchedule: WorkSchedule(
                workScheduleID: work['ws_id'].toString(),
                workScheduleStartDate: DateTime.parse(work['startdate']),
                workScheduleEndDate: DateTime.parse(work['enddate']),
                workScheduleNote: work['note'].toString(),
                workScheduleBarberID: work['ba_id'].toString(),
                workScheduleStatus: work['status'] as int,
              ),
            ));
          }
        }
        Provider.of<DataManagerProvider>(context, listen: false)
            .setBarberWorkSchedule(workScheduleList);
      } else {
        Provider.of<DataManagerProvider>(context, listen: false)
            .setBarberWorkSchedule([]);
      }
      // showErrorDialog(data['message'], context);
    } else {
      Provider.of<DataManagerProvider>(context, listen: false)
          .setBarberWorkSchedule([]);
      showErrorDialog('ไม่สามารถติดต่อเซิร์ฟเวอร์ได้', context);
    }
  } catch (e) {
    showErrorDialog('$e', context);
    Provider.of<DataManagerProvider>(context, listen: false)
        .setBarberWorkSchedule([]);
  }
}

Future<void> getAllLocation(BuildContext context) async {
  List<LocationInfo> locationList = [];
  final String id = Provider.of<DataManagerProvider>(context, listen: false)
      .customerProfile
      .customerId;
  try {
    final url = Uri.parse('$server/get_all_location.php/?id=$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        var locationData = data['data'];
        if (locationData is List) {
          for (var location in locationData) {
            locationList.add(LocationInfo(
                locationId: location['id'].toString(),
                locationName: location['name'].toString(),
                locationLatitude: location['latitude'].toDouble(),
                locationLongitude: location['longitude'].toDouble(),
                locationCusId: location['cus_id'].toString()));
          }
        }
        Provider.of<DataManagerProvider>(context, listen: false)
            .setAllLocation(locationList);
      }
    }
  } catch (e) {
    showErrorDialog('$e', context);
  }
}

Future<bool> addHair(
    HairModel hair, File? imageFile, BuildContext context) async {
  try {
    const url = '$server/add_hair.php';
    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.fields['photo'] = hair.hairPhoto;
    request.fields['ba_id'] = hair.barberId;
    request.fields['name'] = hair.hairName;
    request.fields['price'] = hair.hairPrice.toString();

    if (imageFile != null) {
      List<int> imageBytes = await imageFile.readAsBytes();

      var multipartFile = http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: 'hair.jpg',
      );

      request.files.add(multipartFile);
    }
    var response = await request.send();
    var responseString = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(responseString);
      if (data['result'] == 1) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('สำเร็จ'),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () async {
                    await getHairs(hair.barberId, context);
                    Navigator.pop(context);
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            );
          },
        );
        return true;
      } else {
        showErrorDialog(data['message'], context);
        return false;
      }
    }
  } catch (e) {
    showErrorDialog('$e', context);
    return false;
  }
  return false;
}

Future<bool> addCertificate(certificateModel certificate, List<File> imageFiles,
    BuildContext context) async {
  try {
    const url = '$server/add_certificate.php';
    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.fields['photo'] = certificate.certificatesPhoto;
    request.fields['ba_id'] = certificate.certificatesBarberID;

    for (var imageFile in imageFiles) {
      List<int> imageBytes = await imageFile.readAsBytes();
      var multipartFile = http.MultipartFile.fromBytes(
        'images[]', // using 'images[]' to indicate multiple files
        imageBytes,
        filename: imageFile.path.split('/').last,
      );
      request.files.add(multipartFile);
    }

    var response = await request.send();
    var responseString = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(responseString);
      if (data['result'] == 1) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('สำเร็จ'),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () async {
                    await getCertificates(
                        certificate.certificatesBarberID, context);
                    Navigator.pop(context);
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            );
          },
        );
        return true;
      } else {
        showErrorDialog(data['message'], context);
        return false;
      }
    }
  } catch (e) {
    showErrorDialog('$e', context);
    return false;
  }
  return false;
}

Future<bool> addLocation(
    LocationInfo locationModel, BuildContext context) async {
  try {
    const url = '$server/add_location.php';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'name': locationModel.locationName,
        'latitude': locationModel.locationLatitude.toString(),
        'longitude': locationModel.locationLongitude.toString(),
        'cus_id': locationModel.locationCusId,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('แจ้งเตือน'),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () async {
                    await getAllLocation(context);
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            );
          },
        );
        return true;
      } else {
        showErrorDialog(data['message'], context);
        return false;
      }
    } else {
      showErrorDialog('เชื่อมต่อกับเซิร์ฟเวอร์ล้มเหลว', context);
      return false;
    }
  } catch (e) {
    showErrorDialog('$e', context);
    return false;
  }
}

Future<bool> addWorkSchedule(WorkSchedule model, BuildContext context) async {
  final String id = Provider.of<DataManagerProvider>(context, listen: false)
      .barberProfile
      .barberId;
  try {
    const url = '$server/add_workSchedule.php';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'note': model.workScheduleNote,
        'startdate': model.workScheduleStartDate.toString(),
        'enddate': model.workScheduleEndDate.toString(),
        'status': model.workScheduleStatus.toString(),
        'ba_id': id,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        // showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return AlertDialog(
        //       title: const Text('สำเร็จ'),
        //       content: Text(data['message']),
        //       actions: [
        //         TextButton(
        //           onPressed: () async {
        //             // await getAllWorkSchedule(context);
        //             // Navigator.popUntil(context, (route) => route.isFirst);
        //              Navigator.pop(context);
        //           },
        //           child: const Text('ตกลง'),
        //         ),
        //       ],
        //     );
        //   },
        // );
        return true;
      } else {
        showErrorDialog(data['message'], context);
        return false;
      }
    } else {
      showErrorDialog('เชื่อมต่อกับเซิร์ฟเวอร์ล้มเหลว', context);
      return false;
    }
  } catch (e) {
    showErrorDialog('$e', context);
    return false;
  }
}

Future<bool> addPayment(
    String wsId, PaymentModel model, BuildContext context) async {
  final String id = Provider.of<DataManagerProvider>(context, listen: false)
      .barberProfile
      .barberId;
  try {
    const url = '$server/add_payment.php';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'amount': model.paymentAmount.toString(),
        'bk_id': model.bookingId.toString(),
        'ws_id': wsId,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('แจ้งเตือน'),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () async {
                    await getBarberBooking(id, context);
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            );
          },
        );
        return true;
      } else {
        showErrorDialog(data['message'], context);
        return false;
      }
    } else {
      showErrorDialog('เชื่อมต่อกับเซิร์ฟเวอร์ล้มเหลว', context);
      return false;
    }
  } catch (e) {
    showErrorDialog('$e', context);
    return false;
  }
}

Future<void> addBooking(BookingInfo model, BuildContext context) async {
  try {
    const url = '$server/add_booking.php';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'ws_id': model.workScheduleId,
        'cus_id': model.customerId.toString(),
        'ba_id': model.barberId.toString(),
        'hair_id': model.hairId.toString(),
        'lo_id': model.locationId,
        'startdate': model.startTime.toString(),
        'status': model.bookingStatus.toString(),
        'price': model.bookingPrice.toString(),
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('สำเร็จ'),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () async {
                    await getAllWorkSchedule(context);
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            );
          },
        );
      } else {
        showErrorDialog(data['message'], context);
      }
    } else {
      showErrorDialog('เชื่อมต่อกับเซิร์ฟเวอร์ล้มเหลว', context);
    }
  } catch (e) {
    showErrorDialog('$e', context);
  }
}

Future<void> confirmBooking(String id, BuildContext context) async {
  final String barberId =
      Provider.of<DataManagerProvider>(context, listen: false)
          .barberProfile
          .barberId;
  try {
    const url = '$server/confirm_booking.php';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'id': id.toString(),
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('สำเร็จ'),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () async {
                    await getBarberBooking(barberId, context);
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            );
          },
        );
      } else {
        showErrorDialog(data['message'], context);
      }
    } else {
      showErrorDialog('เชื่อมต่อกับเซิร์ฟเวอร์ล้มเหลว', context);
    }
  } catch (e) {
    showErrorDialog('$e', context);
  }
}

Future<void> cancelBooking(String id, BuildContext context) async {
  final String barberId =
      Provider.of<DataManagerProvider>(context, listen: false)
          .barberProfile
          .barberId;
  try {
    const url = '$server/cancel_booking.php';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'id': id.toString(),
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('สำเร็จ'),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () async {
                    await getBarberBooking(barberId, context);
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            );
          },
        );
      } else {
        showErrorDialog(data['message'], context);
      }
    } else {
      showErrorDialog('เชื่อมต่อกับเซิร์ฟเวอร์ล้มเหลว', context);
    }
  } catch (e) {
    showErrorDialog('$e', context);
  }
}

Future<void> fateBooking(String id, BuildContext context) async {
  final String barberId =
      Provider.of<DataManagerProvider>(context, listen: false)
          .barberProfile
          .barberId;
  try {
    const url = '$server/fate_booking.php';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'id': id.toString(),
        'ba_id': barberId.toString(),
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('สำเร็จ'),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () async {
                    await getBarberBooking(barberId, context);
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            );
          },
        );
      } else {
        showErrorDialog(data['message'], context);
      }
    } else {
      showErrorDialog('เชื่อมต่อกับเซิร์ฟเวอร์ล้มเหลว', context);
    }
  } catch (e) {
    showErrorDialog('$e', context);
  }
}

Future<void> reachedBooking(String id, BuildContext context) async {
  final String barberId =
      Provider.of<DataManagerProvider>(context, listen: false)
          .barberProfile
          .barberId;
  try {
    const url = '$server/reached_booking.php';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'id': id.toString(),
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('สำเร็จ'),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () async {
                    await getBarberBooking(barberId, context);
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            );
          },
        );
      } else {
        showErrorDialog(data['message'], context);
      }
    } else {
      showErrorDialog('เชื่อมต่อกับเซิร์ฟเวอร์ล้มเหลว', context);
    }
  } catch (e) {
    showErrorDialog('$e', context);
  }
}

Future<void> updateHair(
    HairModel hairModel, BuildContext context, File? imageFile) async {
  try {
    const url = '$server/update_hair.php';
    var request = http.MultipartRequest('POST', Uri.parse(url));

    request.fields['id'] = hairModel.hairId;
    request.fields['ba_id'] = hairModel.barberId;
    request.fields['name'] = hairModel.hairName;
    request.fields['photo'] = hairModel.hairPhoto;
    request.fields['price'] = hairModel.hairPrice.toString();

    if (imageFile != null) {
      List<int> imageBytes = await imageFile.readAsBytes();

      var multipartFile = http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: 'hair.jpg',
      );

      request.files.add(multipartFile);
    }

    var response = await request.send();

    var responseString = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(responseString);

      if (data['result'] == 1) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('แจ้งเตือน'),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () async {
                    await getHairs(hairModel.barberId, context);
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            );
          },
        );
      } else {
        showErrorDialog(data['message'], context);
      }
    } else {
      showErrorDialog('เชื่อมต่อกับเซิร์ฟเวอร์ล้มเหลว', context);
    }
  } catch (e) {
    showErrorDialog('$e', context);
  }
}

Future<void> updateLocation(
    LocationInfo locationModel, BuildContext context) async {
  try {
    const url = '$server/update_location.php';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'id': locationModel.locationId,
        'name': locationModel.locationName,
        'latitude': locationModel.locationLatitude.toString(),
        'longitude': locationModel.locationLongitude.toString(),
        'cus_id': locationModel.locationCusId,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('แจ้งเตือน'),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () async {
                    await getAllLocation(context);
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            );
          },
        );
      } else {
        showErrorDialog(data['message'], context);
      }
    } else {
      showErrorDialog('เชื่อมต่อกับเซิร์ฟเวอร์ล้มเหลว', context);
    }
  } catch (e) {
    showErrorDialog('$e', context);
  }
}

Future<void> updateBarberLocation(
    BarberInfo model, BuildContext context) async {
  try {
    const url = '$server/update_barber_location.php';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'id': model.barberId,
        'name': model.barberNamelocation,
        'latitude': model.barberLatitude.toString(),
        'longitude': model.barberLongitude.toString(),
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        final Map<String, dynamic> userData = data['data'];
        String id = userData['id'].toString();
        String name = userData['name'].toString();
        String lastname = userData['lastname'].toString();
        String phone = userData['phone'].toString();
        String email = userData['email'].toString();
        String idcard = userData['idcard'].toString();
        String namelocation = userData['namelocation'].toString();
        double latitude = userData['latitude'];
        double longitude = userData['longitude'];
        BarberInfo barberData = BarberInfo(
            barberId: id,
            barberFirstName: name,
            barberLastName: lastname,
            barberPhone: phone,
            barberEmail: email,
            barberPassword: "",
            barberIDCard: idcard,
            barberNamelocation: namelocation,
            barberLatitude: latitude,
            barberLongitude: longitude);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('สำเร็จ'),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () async {
                    Provider.of<DataManagerProvider>(context, listen: false)
                        .setBarberProfile(barberData);
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            );
          },
        );
      } else {
        showErrorDialog(data['message'], context);
      }
    } else {
      showErrorDialog('เชื่อมต่อกับเซิร์ฟเวอร์ล้มเหลว', context);
    }
  } catch (e) {
    showErrorDialog('$e', context);
  }
}

Future<void> editProfileBarber(
    BarberInfo barberModel, BuildContext context) async {
  try {
    const url = '$server/edit_barber_profile.php';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'id': barberModel.barberId,
        'name': barberModel.barberFirstName,
        'lastname': barberModel.barberLastName,
        'email': barberModel.barberEmail,
        'phone': barberModel.barberPhone,
        'password': barberModel.barberPassword,
        'idcard': barberModel.barberIDCard,
        'namelocation': barberModel.barberNamelocation,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        final Map<String, dynamic> userData = data['data'];
        String id = userData['id'].toString();
        String name = userData['name'].toString();
        String lastname = userData['lastname'].toString();
        String phone = userData['phone'].toString();
        String email = userData['email'].toString();
        String idcard = userData['idcard'].toString();
        String namelocation = userData['namelocation'].toString();
        double latitude = userData['latitude'];
        double longitude = userData['longitude'];
        BarberInfo barberData = BarberInfo(
            barberId: id,
            barberFirstName: name,
            barberLastName: lastname,
            barberPhone: phone,
            barberEmail: email,
            barberPassword: "",
            barberIDCard: idcard,
            barberNamelocation: namelocation,
            barberLatitude: latitude,
            barberLongitude: longitude);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('สำเร็จ'),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () async {
                    Provider.of<DataManagerProvider>(context, listen: false)
                        .setBarberProfile(barberData);
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            );
          },
        );
      } else {
        showErrorDialog(data['message'], context);
      }
    } else {
      showErrorDialog('เชื่อมต่อกับเซิร์ฟเวอร์ล้มเหลว', context);
    }
  } catch (e) {
    showErrorDialog('$e', context);
  }
}

Future<void> editProfileCustomer(
    CustomerInfo customerModel, BuildContext context) async {
  try {
    const url = '$server/edit_customer_profile.php';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'id': customerModel.customerId,
        'name': customerModel.customerFirstName,
        'lastname': customerModel.customerLastName,
        'email': customerModel.customerEmail,
        'phone': customerModel.customerPhone,
        'password': customerModel.customerPassword
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        final Map<String, dynamic> userData = data['data'];
        String id = userData['id'].toString();
        String name = userData['name'].toString();
        String lastname = userData['lastname'].toString();
        String email = userData['email'].toString();
        String phone = userData['phone'].toString();
        final cusData = CustomerInfo(
          customerId: id,
          customerFirstName: name,
          customerLastName: lastname,
          customerEmail: email,
          customerPhone: phone,
          customerPassword: '',
        );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('สำเร็จ'),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () async {
                    Provider.of<DataManagerProvider>(context, listen: false)
                        .setCustomerProfile(cusData);
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            );
          },
        );
      } else {
        showErrorDialog(data['message'], context);
      }
    }
  } catch (e) {
    showErrorDialog('$e', context);
  }
}

Future<void> deleteCertificate(
    String barberId, String id, String photo, BuildContext context) async {
  try {
    final url = '$server/delete_certificate.php?id=$id&photo=$photo';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('แจ้งเตือน'),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () async {
                    await getCertificates(barberId, context);
                    Navigator.pop(context);
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            );
          },
        );
      } else {
        showErrorDialog(data['message'], context);
      }
    } else {
      showErrorDialog('เชื่อมต่อกับเซิร์ฟเวอร์ล้มเหลว', context);
    }
  } catch (e) {
    showErrorDialog('$e', context);
  }
}

Future<void> deleteLocation(String id, BuildContext context) async {
  try {
    final url = '$server/delete_location.php?id=$id';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('แจ้งเตือน'),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () async {
                    await getAllLocation(context);
                    Navigator.pop(context);
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            );
          },
        );
      } else {
        showErrorDialog(data['message'], context);
      }
    } else {
      showErrorDialog('เชื่อมต่อกับเซิร์ฟเวอร์ล้มเหลว', context);
    }
  } catch (e) {
    showErrorDialog('$e', context);
  }
}

Future<bool> deleteWorkSchedule(String id, BuildContext context) async {
  try {
    final url = '$server/delete_workSchedule.php?id=$id';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('แจ้งเตือน'),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            );
          },
        );
        return true;
      } else {
        showErrorDialog(data['message'], context);
        return false;
      }
    } else {
      showErrorDialog('เชื่อมต่อกับเซิร์ฟเวอร์ล้มเหลว', context);
      return false;
    }
  } catch (e) {
    showErrorDialog('$e', context);
    return false;
  }
}

Future<void> deleteHair(
    String id, String barberId, BuildContext context) async {
  try {
    const url = '$server/delete_hair.php';
    final response = await http.post(
      Uri.parse(url),
      body: {
        'id': id,
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['result'] == 1) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('แจ้งเตือน'),
              content: Text(data['message']),
              actions: [
                TextButton(
                  onPressed: () async {
                    await getHairs(barberId, context);
                    Navigator.pop(context);
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            );
          },
        );
      } else {
        showErrorDialog(data['message'], context);
      }
    } else {
      showErrorDialog('เชื่อมต่อกับเซิร์ฟเวอร์ล้มเหลว', context);
    }
  } catch (e) {
    showErrorDialog('$e', context);
  }
}

void showErrorDialog(String message, context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('ข้อผิดพลาด'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ตกลง'),
          ),
        ],
      );
    },
  );
}
