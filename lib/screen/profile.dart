// import 'dart:convert';
// import 'package:finalprojectbarber/login.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;

// import '../widgets/logout.dart';

// class UserProfile extends StatefulWidget {
//   @override
//   _UserProfileState createState() => _UserProfileState();
// }

// class _UserProfileState extends State<UserProfile> {
//   late String name;
//   late String lastName;
//   late String phone;
//   late String email;

//   XFile? _imageFile;
//   late String _pickedFile;

//   Future<void> uploadImage(XFile imageFile) async {
//     try {
//       final userProvider = Provider.of<UserProvider>(context, listen: false);
//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse('http://127.0.0.1/user/upload.php'),
//       );

//       // Add user_id to the request
//       request.fields['user_id'] = userProvider.getUserId();

//       // Convert the image file to bytes
//       List<int> imageBytes = await imageFile.readAsBytes();

//       // Create a MultipartFile from the image bytes
//       var multipartFile = http.MultipartFile.fromBytes(
//         'image',
//         imageBytes,
//         filename: 'workings.jpg',
//       );

//       // Add the MultipartFile to the request
//       request.files.add(multipartFile);

//       var response = await request.send();
//       if (response.statusCode == 200) {
//         print('Image uploaded successfully');
//       } else {
//         print('Failed to upload image. Status code: ${response.statusCode}');
//       }
//     } catch (error) {
//       print('Error uploading image: $error');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     // กำหนดค่าเริ่มต้นใน initState

//     // กำหนดค่าให้กับตัวแปรที่ใช้เก็บข้อมูล
//     name = "";
//     lastName = "";
//     phone = "";
//     email = "";
//     fetchUserProfile();

//     // เรียกเมธอดเพื่อดึงข้อมูลโปรไฟล์ผู้ใช้
//   }

//   Future<void> fetchUserProfile() async {
//     // URL API ที่ต้องการเรียก (แทนที่ด้วย URL ของ API จริง)
//     final url = Uri.parse('http://127.0.0.1/user/showprofile.php');
//     final userProvider = Provider.of<UserProvider>(context, listen: false);
//     try {
//       final response = await http.post(
//         url,
//         body: {'user_id': userProvider.getUserId()},
//       );

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = json.decode(response.body);
//         final Map<String, dynamic> userData = data['data'];

//         // Use null-aware operators to handle null values
//         String _name = userData['user_name'] ?? '';
//         String _lastName = userData['user_lastname'] ?? '';
//         String _phone = userData['user_phone'] ?? '';
//         String _email = userData['user_email'] ?? '';

//         setState(() {
//           name = _name;
//           lastName = _lastName;
//           phone = _phone;
//           email = _email;
//         });
//       } else {
//         print('Unexpected data format');
//       }
//     } catch (error) {
//       print('Error loading user profile: $error');
//     }
//   }

//   void _logout(BuildContext context) {
//     Navigator.pushReplacementNamed(context, '/login');
//   }

//   Widget itemProfile(String title, String subtitle, IconData iconData) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//             offset: Offset(0, 5),
//             color: Colors.deepOrange.withOpacity(.2),
//             spreadRadius: 2,
//             blurRadius: 10,
//           ),
//         ],
//       ),
//       child: ListTile(
//         title: Text(title),
//         subtitle: Text(subtitle),
//         leading: Icon(iconData),
//         trailing: Icon(Icons.arrow_forward, color: Colors.grey.shade400),
//         tileColor: Colors.white,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: ListView(
//           children: [
//             // รูปโปรไฟล์
//             const SizedBox(height: 40),
//             CircleAvatar(
//               radius: 58,
//               child: Stack(
//                 children: [
//                   Align(
//                     alignment: Alignment.bottomRight,
//                     child: CircleAvatar(
//                       radius: 18,
//                       backgroundColor: Colors.white70,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // ข้อมูล
//             const SizedBox(height: 20),
//             itemProfile('Name', name, Icons.person),
//             const SizedBox(height: 10),
//             itemProfile('LastName', lastName, Icons.person),
//             const SizedBox(height: 10),
//             itemProfile('Phone', phone, Icons.phone),
//             const SizedBox(height: 10),
//             itemProfile('Email', email, Icons.mail),
//             const SizedBox(
//               height: 20,
//             ),

//             // ปุ่ม
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/edit_profile');
//               },
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.all(15),
//               ),
//               child: const Text('Edit Profile'),
//             ),
//             const SizedBox(
//               height: 20,
//             ),

//             // Card ด้านล่าง Edit Profile
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   _imageFile != null
//                       ? Image.network(
//                           _pickedFile, // ใส่ URL ของรูปภาพที่ต้องการแสดง
//                           height: 150,
//                         )
//                       : Container(
//                           height: 150,
//                           color: Colors.grey[200],
//                           child: Icon(Icons.image, size: 50),
//                         ),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () async {
//                       final picker = ImagePicker();
//                       final pickedFile =
//                           await picker.pickImage(source: ImageSource.gallery);

//                       if (pickedFile != null) {
//                         setState(() {
//                           _imageFile = XFile(pickedFile.path);
//                           _pickedFile = pickedFile.path;
//                         });
//                       }
//                     },
//                     child: Text('เพิ่มรูป'),
//                   ),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () async {
//                       if (_imageFile != null) {
//                         // ทำการอัปโหลดรูปภาพที่เลือก
//                         await uploadImage(_imageFile!);
//                       } else {
//                         print('กรุณาเลือกรูปภาพก่อนทำการอัปโหลด');
//                       }
//                     },
//                     child: Text('อัปโหลดรูป'),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(
//               height: 20,
//             ),
//             // ปุ่มออก
//             ElevatedButton(
//               onPressed: () {
//                 Logout().accountLogout().whenComplete(() {
//                   Navigator.of(context).pushAndRemoveUntil(
//                       MaterialPageRoute(builder: (context) => const LoginPage()),
//                       (Route<dynamic> route) => false);
//                 });
//               },
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.all(15),
//               ),
//               child: const Text('Logout'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
