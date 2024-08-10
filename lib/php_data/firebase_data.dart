// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// import 'package:provider/provider.dart';

// import '../data_manager/data_manager.dart';
// import '../model/barber_model.dart';

// // Future<void> addCustomerProfileData(
// //     CustomerInfo user, BuildContext context) async {
// //   try {
// //     await FirebaseFirestore.instance.collection('Customer').add({
// //       'customerId': user.customerId,
// //       'fullName': user.customerFullName,
// //       'email': user.customerEmail,
// //       'contact': user.customerContact,
// //     });
// //   } catch (e) {
// //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
// //   }
// // }

// // Future<void> getCustomerProfile(BuildContext context) async {
// //   try {
// //     final userData = CustomerInfo(
// //       customerId: 'customerId',
// //       customerPassword: '',
// //       customerFullName: 'Sukanya Chinkham',
// //       customerEmail: 'Sukanya@gmail.com',
// //       customerContact: '0639781398',
// //       roll: 'Customer',
// //     );
// //     Provider.of<DataManagerProvider>(context, listen: false)
// //         .setCustomerProfile(userData);
// //   } catch (e) {
// //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
// //   }
// // }

// // Future<void> getBarberProfile(email, BuildContext context) async {
// //   try {
// //     final userProfile = await FirebaseFirestore.instance
// //         .collection('Barbers')
// //         .where('email', isEqualTo: email)
// //         .get();
// //     late BarberModel barbP;

// //     for (var data in userProfile.docs) {
// //       BarberInfo barber = BarberInfo(
// //           barberId: data['barberId'],
// //           barberFullName: data['fullName'],
// //           barberEmail: data['email'],
// //           barberContact: data['contact'],
// //           roll: 'Barbers',
// //           barberPassword: '');

// //       Location location = Location(
// //           address: data['address'],
// //           latitude: data['latitude'],
// //           longitude: data['longitude']);

// //       ShopStatus status = ShopStatus(
// //           status: data['shopStatus'],
// //           startTime: data['startTime'],
// //           endTime: data['endTime']);

// //       barbP = BarberModel(
// //           shopName: data['shopName'],
// //           barber: barber,
// //           seats: data['seats'],
// //           description: data['description'],
// //           rating: double.parse("${data['rating']}"),
// //           goodReviews: data['goodReviews'],
// //           totalScore: data['totalScore'],
// //           satisfaction: data['satisfaction'],
// //           image: data['image'],
// //           location: location,
// //           shopStatus: status);
// //     }
// //     Provider.of<DataManagerProvider>(context, listen: false)
// //         .setBarberProfile(barbP);
// //   } catch (e) {
// //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
// //   }
// // }

// // Future<void> addBarberProfileData(BuildContext context) async {
// //   final barber =
// //       Provider.of<DataManagerProvider>(context, listen: false).getBarberDetails;
// //   try {
// //     await FirebaseFirestore.instance.collection('Barbers').add({
// //       'barberId': barber.barber.barberId,
// //       'fullName': barber.barber.barberFullName,
// //       'shopName': barber.shopName,
// //       'email': barber.barber.barberEmail,
// //       'contact': barber.barber.barberContact,
// //       'seats': barber.seats,
// //       'description': barber.description,
// //       'rating': 0.0,
// //       'goodReviews': 0,
// //       'totalScore': 0,
// //       'satisfaction': 0,
// //       'image': barber.image,
// //       'address': barber.location.address,
// //       'latitude': barber.location.latitude,
// //       'longitude': barber.location.longitude,
// //       'startTime': barber.shopStatus.startTime,
// //       'endTime': barber.shopStatus.endTime,
// //       'shopStatus': barber.shopStatus.status,
// //     });

// //     await FirebaseFirestore.instance.collection('Top Barbers').add({
// //       'barberId': barber.barber.barberId,
// //       'fullName': barber.barber.barberFullName,
// //       'shopName': barber.shopName,
// //       'email': barber.barber.barberEmail,
// //       'contact': barber.barber.barberContact,
// //       'seats': barber.seats,
// //       'description': barber.description,
// //       'rating': 0.0,
// //       'goodReviews': 0,
// //       'totalScore': 0,
// //       'satisfaction': 0,
// //       'image': barber.image,
// //       'address': barber.location.address,
// //       'latitude': barber.location.latitude,
// //       'longitude': barber.location.longitude,
// //       'startTime': barber.shopStatus.startTime,
// //       'endTime': barber.shopStatus.endTime,
// //       'shopStatus': barber.shopStatus.status,
// //     });
// //   } catch (e) {
// //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
// //   }
// // }

// Future<void> getAllBarbers(BuildContext context) async {
//   // final result = await FirebaseFirestore.instance.collection('Barbers').get();

//   List<BarberModel> barberList = [];

// // for (var data in result.docs) {
//   BarberInfo barber = BarberInfo(
//     barberId: 'barberId',
//     barberFullName: 'fullName',
//     barberEmail: 'email',
//     barberContact: 'contact',
//     roll: 'Barber',
//     barberPassword: '',
//   );

//   Location location = Location(
//     address: '123 Street, City',
//     latitude: 40.7128,
//     longitude: -74.0060,
//   );

//   ShopStatus status = ShopStatus(
//     status: 'shopStatus',
//     startTime: 'startTime',
//     endTime: 'endTime',
//   );

//   barberList.add(BarberModel(
//     shopName: 'shopName',
//     barber: barber,
//     seats: 'seats',
//     description: 'description',
//     rating: 5.5,
//     goodReviews: 100,
//     totalScore: 100,
//     satisfaction: 100,
//     image: 'image',
//     location: location,
//     shopStatus: status,
//   ));
// // }
//   Provider.of<DataManagerProvider>(context, listen: false)
//       .setAllBarbers(barberList);
// }

// // Future<void> getTopBarbers(BuildContext context) async {
// //   final result =
// //       await FirebaseFirestore.instance.collection('Top Barbers').get();

// //   List<BarberModel> topList = [];

// //   for (var data in result.docs) {
// //     BarberInfo barber = BarberInfo(
// //         barberId: data['barberId'],
// //         barberFullName: data['fullName'],
// //         barberEmail: data['email'],
// //         barberContact: data['contact'],
// //         roll: 'Barber',
// //         barberPassword: '');

// //     Location location = Location(
// //         address: data['address'],
// //         latitude: data['latitude'],
// //         longitude: data['longitude']);

// //     ShopStatus status = ShopStatus(
// //         status: data['shopStatus'],
// //         startTime: data['startTime'],
// //         endTime: data['endTime']);

// //     topList.add(BarberModel(
// //         shopName: data['shopName'],
// //         barber: barber,
// //         seats: data['seats'],
// //         description: data['description'],
// //         rating: double.parse("${data['rating']}"),
// //         goodReviews: data['goodReviews'],
// //         totalScore: data['totalScore'],
// //         satisfaction: data['satisfaction'],
// //         image: data['image'],
// //         location: location,
// //         shopStatus: status));
// //   }
// //   Provider.of<DataManagerProvider>(context, listen: false)
// //       .setTopBarbers(topList);
// // }

// /////////////////////////Appointment
// // Future<void> setAppointment(AppointmentModel model) async {
// //   await FirebaseFirestore.instance.collection('Appointments').add({
// //     'customerId': model.customerId,
// //     'barberId': model.barberId,
// //     'seatNo': model.seatNo,
// //     'startTime': model.startTime,
// //     'endTime': model.endTime,
// //     'shopName': model.shopName,
// //     'shopAddress': model.shopAddress,
// //     'barberContact': model.barberContact,
// //     'status': model.appointmentStatus,
// //   });
// // }

// Future<void> getAppointmentFromFirebase(
//     String barberId, BuildContext context) async {
//   final result = await FirebaseFirestore.instance
//       .collection('Appointments')
//       .where('barberId', isEqualTo: barberId)
//       .get();
//   List<AppointmentModel> app = [];
//   for (var data in result.docs) {
//     app.add(AppointmentModel(
//         customerId: data['customerId'],
//         barberId: data['barberId'],
//         startTime: data['startTime'],
//         endTime: data['endTime'],
//         seatNo: data['seatNo'],
//         appointmentStatus: data['status'],
//         shopAddress: data['shopAddress'],
//         shopName: data['shopName'],
//         barberContact: data['barberContact']));
//   }
//   Provider.of<DataManagerProvider>(context, listen: false)
//       .setAppointmentList(app);
// }

// // Future<void> getMyAppointmentsFromFirebase(
// //     String myid, BuildContext context) async {
// //   final result = await FirebaseFirestore.instance
// //       .collection('Appointments')
// //       .where('customerId', isEqualTo: myid)
// //       .get();
// //   List<AppointmentModel> app = [];
// //   for (var data in result.docs) {
// //     app.add(AppointmentModel(
// //         customerId: data['customerId'],
// //         barberId: data['barberId'],
// //         startTime: data['startTime'],
// //         endTime: data['endTime'],
// //         seatNo: data['seatNo'],
// //         appointmentStatus: data['status'],
// //         shopAddress: data['shopAddress'],
// //         shopName: data['shopName'],
// //         barberContact: data['barberContact']));
// //   }
// //   Provider.of<DataManagerProvider>(context, listen: false)
// //       .setMyAppointments(app);
// // }

// // Future<void> getMyAppointmentWithBarberFromFirebase(
// //     String id, BuildContext context) async {
// //   try {
// //     final userProfile = await FirebaseFirestore.instance
// //         .collection('Barbers')
// //         .where('barberId', isEqualTo: id)
// //         .get();
// //     late BarberModel barbP;

// //     for (var data in userProfile.docs) {
// //       BarberInfo barber = BarberInfo(
// //           barberId: data['barberId'],
// //           barberFullName: data['fullName'],
// //           barberEmail: data['email'],
// //           barberContact: data['contact'],
// //           roll: 'Barber',
// //           barberPassword: '');

// //       Location location = Location(
// //           address: data['address'],
// //           latitude: data['latitude'],
// //           longitude: data['longitude']);

// //       ShopStatus status = ShopStatus(
// //           status: data['shopStatus'],
// //           startTime: data['startTime'],
// //           endTime: data['endTime']);

// //       barbP = BarberModel(
// //           shopName: data['shopName'],
// //           barber: barber,
// //           seats: data['seats'],
// //           description: data['description'],
// //           rating: double.parse("${data['rating']}"),
// //           goodReviews: data['goodReviews'],
// //           totalScore: data['totalScore'],
// //           satisfaction: data['satisfaction'],
// //           image: data['image'],
// //           location: location,
// //           shopStatus: status);
// //     }
// //     Provider.of<DataManagerProvider>(context, listen: false)
// //         .setMyAppointmentWithBarber(barbP);
// //   } catch (e) {
// //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
// //   }
// // }
