// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class UserSearch extends StatefulWidget {
//   @override
//   _UserSearchState createState() => _UserSearchState();
// }

// class _UserSearchState extends State<UserSearch> {
//   late Future<List<Map<String, dynamic>>> userData;
//   @override
//   void initState() {
//     super.initState();
//     // Replace the API endpoint with your actual endpoint
//     final userProvider = Provider.of<UserProvider>(context, listen: false);
//     userData = fetchData('http://127.0.0.1/user/jobschedule.php', {
//       'user_id': userProvider.getUserId(), // Replace with the actual user ID
//     });
//   }

//   Future<List<Map<String, dynamic>>> fetchData(
//       String url, Map<String, dynamic> body) async {
//     final response = await http.post(
//       Uri.parse(url),
//       body: body,
//     );

//     if (response.statusCode == 200) {
//       Map<String, dynamic> jsonResponse = json.decode(response.body);
//       List<dynamic> dataList = jsonResponse['data'];
//       List<Map<String, dynamic>> resultList =
//           dataList.map((item) => Map<String, dynamic>.from(item)).toList();
//       return resultList;
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: FutureBuilder<List<Map<String, dynamic>>>(
//             future: userData,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return CircularProgressIndicator();
//               } else if (snapshot.hasError) {
//                 return Text('Error: ${snapshot.error}');
//               } else {
//                 final dataList = snapshot.data!;

//                 if (dataList.isNotEmpty) {
//                   return ListView.separated(
//                     itemCount: dataList.length,
//                     separatorBuilder: (BuildContext context, int index) {
//                       return SizedBox(height: 16);
//                     },
//                     itemBuilder: (context, index) {
//                       final data = dataList[index];
//                       return MyCard(
//                         data: data,
//                       );
//                     },
//                   );
//                 } else {
//                   return Text('No data found');
//                 }
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// class MyCard extends StatefulWidget {
//   final Map<String, dynamic> data;

//   MyCard({
//     required this.data,
//   });

//   @override
//   _MyCardState createState() => _MyCardState(data: data);
// }

// class _MyCardState extends State<MyCard> {
//   final Map<String, dynamic> data;
//   bool isMapVisible = false;
//   bool hasConfirmed = false;
//   bool isProviderMarkerVisible = false;
//   bool hasReachedDestination = false;
//   Set<Polyline> polylines = {};

//   _MyCardState({
//     required this.data,
//   });

//   @override
//   Widget build(BuildContext context) {
//     double? customerLatitude = double.tryParse(data['cus_latitude'] ?? '');
//     double? customerLongitude = double.tryParse(data['cus_longitude'] ?? '');

//     double? providerLatitude = double.tryParse(data['user_latitude'] ?? '');
//     double? providerLongitude = double.tryParse(data['user_longitude'] ?? '');

//     LatLng? customerLocation =
//         (customerLatitude != null && customerLongitude != null)
//             ? LatLng(customerLatitude, customerLongitude)
//             : null;

//     LatLng? providerLocation =
//         (providerLatitude != null && providerLongitude != null)
//             ? LatLng(providerLatitude, providerLongitude)
//             : null;

//     if ( isProviderMarkerVisible && customerLocation != null && providerLocation != null) {
//       // Update polylines
//       polylines.add(
//         Polyline(
//           polylineId: PolylineId('route'),
//           visible: true,
//           points: [
//             LatLng(customerLatitude!, customerLongitude!),
//             LatLng(providerLatitude!, providerLongitude!),
//           ],
//           color: Colors.blue,
//           width: 4,
//         ),
//       );
//     }

//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15.0),
//       ),
//       elevation: 5,
//       child: Column(
//         children: [
//           ListTile(
//             leading: Icon(Icons.person),
//             title: Text(data['cus_name']),
//           ),
//           ListTile(
//             leading: Icon(Icons.phone),
//             title: Text(data['cus_phone']),
//           ),
//           ListTile(
//             leading: Icon(Icons.date_range),
//             title: Text('เวลาเริ่ม: ${data['jobsc_startdate']}'),
//             subtitle: Text('เวลาสิ้นสุด: ${data['jobsc_enddate']}'),
//           ),
//           ListTile(
//             leading: Icon(Icons.location_on),
//             title: Text('ที่อยู่ ${data['namelocation']}'),
//           ),
//           if (isMapVisible && customerLocation != null)
//             Container(
//               height: 200, // Adjust the height as needed
//               child: GoogleMap(
//                 initialCameraPosition: CameraPosition(
//                   target: customerLocation,
//                   zoom: 13.0,
//                 ),
//                 markers: {
//                   Marker(
//                     markerId: MarkerId("customerLocation"),
//                     position: customerLocation,
//                     infoWindow: InfoWindow(title: data['cus_name']),
//                   ),
//                   if (isProviderMarkerVisible && providerLocation != null)
//                     Marker(
//                       markerId: MarkerId("providerLocation"),
//                       position: providerLocation,
//                       infoWindow: InfoWindow(title: "ที่อยู๋"),
//                     ),
                    
//                 },
                
//                 polylines: polylines,
//                 onMapCreated: (GoogleMapController controller) {
//                   // You can use the controller to interact with the map if needed
//                 },
//               ),
//             ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       isMapVisible = true;
//                       if (!hasConfirmed) {
//                         hasConfirmed = true;
//                       } else {
//                         isProviderMarkerVisible = true;
//                         hasReachedDestination = true;
//                       }
//                     });
//                   },
//                   child: Text(hasReachedDestination
//                       ? 'ยืนยันถึงที่หมาย'
//                       : (hasConfirmed ? 'ยืนยันการเดินทาง' : 'ยืนยัน')),
//                 ),
//                 if (!hasConfirmed) const SizedBox(width: 8),
//                 if (!hasConfirmed)
//                   ElevatedButton(
//                     onPressed: () {
//                       // Handle cancellation
//                     },
//                     child: Text('ยกเลิก'),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }