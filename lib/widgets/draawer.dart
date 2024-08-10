// import 'package:finalprojectbarber/login.dart';
// import 'package:finalprojectbarber/widgets/google_map.dart';
// import 'package:finalprojectbarber/widgets/logout.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';



// class Draawer extends StatelessWidget {
//   const Draawer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       elevation: 0.0,
//       backgroundColor: Colors.blueGrey,
//       child: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.only(top: 50.0, left: 10.0),
//           child: Column(
//             children: [
//               Image.asset('assets/logo.png', scale: 5.0,),
//               const Text(
//                 'DeveStyle',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 40.0,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               const SizedBox(
//                 height: 50.0,
//               ),
//               InkWell(
//                   onTap: (){
//                     // print('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaa');
//                      Navigator.push(context, CupertinoPageRoute(builder: (context)=> MapSample()));
//                   },
//                   child: drawerChild(Icons.map_outlined, 'Find Nearby barbers')),
//               InkWell(
//                   onTap: (){
//                     // final myId = Provider.of<DataManagerProvider>(context, listen: false).currentUser.customerId;
//                     // getMyAppointmentsFromFirebase(myId, context).whenComplete(() {
//                     //   Navigator.push(context, CupertinoPageRoute(builder: (context)=> const MyAppointments()));
//                     // });

//                   },
//                   child: drawerChild(Icons.featured_play_list_outlined, 'Appointments')),
//               //drawerChild(Icons.favorite_border_rounded, 'Favorites'),
//               //drawerChild(Icons.history, 'History'),
//               InkWell(
//                   onTap: (){
                   
//                   },
//                   child: drawerChild(Icons.policy_outlined, 'Terms & Policies')),
//               drawerChild(Icons.help_center_outlined, 'Help Center'),
//               Spacer(),
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 50.0),
//                 child: MaterialButton(onPressed: (){
//                   Logout().accountLogout().whenComplete((){
//                     Navigator.of(context).pushAndRemoveUntil(
//                         MaterialPageRoute(builder: (context) => LoginPage()),
//                             (Route<dynamic> route) => false);
//                   });
//                 },
//                   color: Colors.grey[700],
//                 child: const Text('Logout', style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.w900,
//                 ),),),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget drawerChild(IconData icon, String title) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 30.0),
//       child: Row(
//         children: [
//           Icon(
//             icon,
//             size: 30.0,
//             color: Colors.white,
//           ),
//           const SizedBox(
//             width: 20.0,
//           ),
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 20.0,
//               fontWeight: FontWeight.w600,
//               color: Colors.white,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
