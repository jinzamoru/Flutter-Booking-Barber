// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class TimePicker extends StatefulWidget {
//   final DateTime selectedTimestamp;

//   TimePicker(this.selectedTimestamp);

//   @override
//   _TimePickerState createState() => _TimePickerState();
// }

// class _TimePickerState extends State<TimePicker> {
//   DateTime _startTime = DateTime.now();
//   DateTime _endTime = DateTime.now();
//   String _note = "";

//   @override
//   void initState() {
//     super.initState();
//     // ใน initState กำหนด _startTime และ _endTime จาก timestamp
//     _startTime =
//         // DateTime.fromMillisecondsSinceEpoch(widget.selectedTimestamp);
//         _endTime = _startTime
//             .add(Duration(hours: 1)); // เริ่มต้นที่เวลาเริ่มต้น + 1 ชั่วโมง
//   }

//   // void _saveData() async {
//   //   // Add your logic to save data
//   //   // final userProvider = Provider.of<UserProvider>(context, listen: false);
//   //   print(
//   //       'Start Time: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(_startTime.toLocal())}');
//   //   print(
//   //       'End Time: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(_endTime.toLocal())}');
//   //   print('Note: $_note');

//   //   // Send data to the PHP page

//   //   final response = await http.post(
//   //     Uri.parse(
//   //         'http://127.0.0.1/user/picktime.php'), // Replace with your PHP API URL
//   //     body: {
//   //       'user_id': userProvider.getUserId(), // Replace with the actual user ID
//   //       'startdate':
//   //           DateFormat('yyyy-MM-dd HH:mm:ss').format(_startTime.toLocal()),
//   //       'enddate': DateFormat('yyyy-MM-dd HH:mm:ss').format(_endTime.toLocal()),
//   //       'note': _note,
//   //     },
//   //   );

//   //   // Handle the response from PHP
//   //   if (response.statusCode == 200) {
//   //     print('PHP Response: ${response.body}');
//   //     _showSuccessPopup(); // เมื่อบันทึกสำเร็จแสดง popup
//   //   } else {
//   //     print('Failed to connect to PHP page');
//   //   }
//   // }

//   void _showSuccessPopup() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('บันทึกสำเร็จ'),
//           content: Text('ข้อมูลถูกบันทึกเรียบร้อยแล้ว'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // ปิด AlertDialog
//               },
//               child: Text('ตกลง'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Choose Time'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Day: ${DateFormat('yyyy-MM-dd   HH:mm:ss').format(_startTime.toLocal())}',
//               style: TextStyle(fontSize: 20),
//             ),
//             SizedBox(height: 40),
//             Text(
//               'Start Time: ${DateFormat('HH:mm').format(_startTime)}',
//               style: TextStyle(fontSize: 20),
//             ),
//             SizedBox(height: 40),
//             ElevatedButton(
//               onPressed: () {
//                 _pickTime(context, true);
//               },
//               child: Text('Pick Start Time'),
//             ),
//             SizedBox(height: 40),
//             Text(
//               'End Time: ${DateFormat('HH:mm').format(_endTime)}',
//               style: TextStyle(fontSize: 20),
//             ),
//             SizedBox(height: 40),
//             ElevatedButton(
//               onPressed: () {
//                 _pickTime(context, false);
//               },
//               child: Text('Pick End Time'),
//             ),
//             SizedBox(height: 20),
//             Padding(
//               padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//               child: TextField(
//                 onChanged: (value) {
//                   setState(() {
//                     _note = value;
//                   });
//                 },
//                 decoration: InputDecoration(
//                   labelText: 'Note',
//                   hintText: 'Enter your note here',
//                   contentPadding:
//                       EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: BorderSide(color: Colors.grey),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide:
//                         BorderSide(color: Theme.of(context).primaryColor),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // _saveData(); // Add your logic to save data
//               },
//               child: Text('Save'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _pickTime(BuildContext context, bool isStartTime) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: isStartTime
//           ? TimeOfDay.fromDateTime(_startTime)
//           : TimeOfDay.fromDateTime(_endTime),
//     );

//     if (picked != null) {
//       setState(() {
//         if (isStartTime) {
//           _startTime = DateTime(
//             _startTime.year,
//             _startTime.month,
//             _startTime.day,
//             picked.hour,
//             picked.minute,
//           );
//           // ป้องกันให้ _endTime เกินเวลา _startTime
//           if (_startTime.isAfter(_endTime)) {
//             _endTime = _startTime.add(Duration(hours: 1));
//           }
//         } else {
//           _endTime = DateTime(
//             _endTime.year,
//             _endTime.month,
//             _endTime.day,
//             picked.hour,
//             picked.minute,
//           );
//           // ป้องกันให้ _endTime เกินเวลา _startTime
//           if (_endTime.isBefore(_startTime)) {
//             _startTime = _endTime.subtract(Duration(hours: 1));
//           }
//         }
//       });
//     }
//   }

//   void _updateProfile(BuildContext context) {
//     // Implement logic to update profile information
//     // ...

//     // Navigate back to the profile page after updating
//     Navigator.pop(context);
//   }
// }
