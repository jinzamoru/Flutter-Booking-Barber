// import 'package:flutter/material.dart';
// import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// import '../../data_manager/data_manager.dart';
// import '../../widgets/barber_dashboard_timline.dart';
// import '../../widgets/dashboard/barber_draawer.dart';

// class BarberDashboard extends StatefulWidget {
//   BarberDashboard({Key? key}) : super(key: key);

//   @override
//   State<BarberDashboard> createState() => _BarberDashboardState();
// }

// class _BarberDashboardState extends State<BarberDashboard> {

//   DateTime now = DateTime.now();
//   late DateTime startTime;
//   late DateTime endTime;
//   late Duration step;

//   List<String> timeSlots = [];
//   late DateTime sTime;
//   late DateTime eTime;

//   bool isOpen = false;

//   @override
//   initState() {
//     getTIme();
//     super.initState();
//   }

//   Future<void> getTIme() async {
//     initializeDateFormatting();

//     // final stTime =  Provider.of<DataManagerProvider>(context, listen: false)
//     //     .getBarberProfile
//     //     .shopStatus
//     //     .startTime;
//     // final etTime = Provider.of<DataManagerProvider>(context, listen: false)
//     //     .getBarberProfile
//     //     .shopStatus
//     //     .endTime;

//     String esTime = '10:00 AM';
//     String etTime = '9:00 AM';

//     sTime = DateFormat.jm().parse(esTime);
//     eTime = DateFormat.jm().parse(etTime);

//     startTime = DateTime(
//         now.year,
//         now.month,
//         now.day,
//         int.parse(DateFormat("HH").format(sTime)),
//         int.parse(DateFormat("mm").format(sTime)),
//         0);
//     endTime = DateTime(
//         now.year,
//         now.month,
//         now.day,
//         int.parse(DateFormat("HH").format(eTime)),
//         int.parse(DateFormat("mm").format(eTime)),
//         0);
//     step = Duration(minutes: 30);

//     while (startTime.isBefore(endTime)) {
//       DateTime timeIncrement = startTime.add(step);
//       timeSlots.add(DateFormat.Hm().format(timeIncrement));
//       startTime = timeIncrement;
//     }
//     print(timeSlots);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AdvancedDrawer(
//       // AdvancedDrawer configuration...
//       drawer: const BarberDraawer(),
//       child: FutureBuilder<List<String>>(
//         future: simulateDataFetch(), // Simulate data fetching
//         builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator(); // Loading indicator while fetching data
//           } else {
//             if (snapshot.hasError) {
//               return Text(
//                   'Error: ${snapshot.error}'); // Show error message if data fetching fails
//             } else {
//               List<String> timeSlots =
//                   snapshot.data ?? []; // Get the simulated data
//               return Scaffold(
//                 // Scaffold and AppBar configurations...
//                 body: SafeArea(
//                   child: Consumer<DataManagerProvider>(
//                     builder: (context, provider, child) {
//                       return ListView.builder(
//                         itemCount: timeSlots.length ~/ 2,
//                         itemBuilder: (context, index) {
//                           return BarberTimeLine(
//                             // BarberTimeLine widget configurations...
//                             startTime: timeSlots[index],
//                             endTime: timeSlots[index + 1],
//                             seats: 3,
//                             barberId: '',
//                             shopAddress: '',
//                             shopName: '',
//                             barberContact: '',
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               );
//             }
//           }
//         },
//       ),
//     );
//   }

//   // Function to simulate data fetching
//   Future<List<String>> simulateDataFetch() async {
//     await Future.delayed(
//         const Duration(seconds: 2)); // Simulate delay for data fetching
//     List<String> simulatedData = [
//       '09:00 AM', '09:30 AM',
//       '10:00 AM', '10:30 AM',
//       '11:00 AM', '11:30 AM',
//       '12:00 PM', '12:30 PM',
//       // Add more simulated data as needed...
//     ];
//     return simulatedData;
//   }
// }
