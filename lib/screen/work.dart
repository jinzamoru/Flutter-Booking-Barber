// import 'package:flutter/material.dart';
// import 'package:finalprojectbarber/screen/picker.dart';
// import 'package:table_calendar/table_calendar.dart';

// class UserWork extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(    
//       body: Center(
//         child: CalendarWidget(),
//       ),
//     );
//   }
// }

// class CalendarWidget extends StatefulWidget {
//   @override
//   _CalendarWidgetState createState() => _CalendarWidgetState();
// }

// class _CalendarWidgetState extends State<CalendarWidget> {
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   DateTime _focusedDay = DateTime.now();
//   DateTime _selectedDay = DateTime.now();

//   @override
//   Widget build(BuildContext context) {
//     return CustomTableCalendar(
//       calendarFormat: _calendarFormat,
//       focusedDay: _focusedDay,
//       selectedDay: _selectedDay,
//       onDaySelected: (selectedDay, focusedDay) {
//         setState(() {
//           _selectedDay = selectedDay;
//           _focusedDay = focusedDay;
//         });

//         int timestampInSeconds = (_selectedDay.millisecondsSinceEpoch ~/ 1000);

//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => TimePicker(timestampInSeconds),
//           ),
//         );
//       },
//       onFormatChanged: (format) {
//         setState(() {
//           _calendarFormat = format;
//         });
//       },
//     );
//   }
// }

// class CustomTableCalendar extends StatelessWidget {
//   final CalendarFormat calendarFormat;
//   final DateTime focusedDay;
//   final DateTime selectedDay;
//   final Function(DateTime, DateTime) onDaySelected;
//   final Function(CalendarFormat) onFormatChanged;

//   CustomTableCalendar({
//     required this.calendarFormat,
//     required this.focusedDay,
//     required this.selectedDay,
//     required this.onDaySelected,
//     required this.onFormatChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TableCalendar(
//       firstDay: DateTime.utc(2021, 1, 1),
//       lastDay: DateTime.utc(2024, 12, 31),
//       focusedDay: focusedDay,
//       calendarFormat: calendarFormat,
//       selectedDayPredicate: (day) {
//         return isSameDay(selectedDay, day);
//       },
//       onDaySelected: (selectedDay, focusedDay) {
//         onDaySelected(selectedDay, focusedDay);
//       },
//       onFormatChanged: (format) {
//         onFormatChanged(format);
//       },
//       calendarBuilders: CalendarBuilders(
//         selectedBuilder: (context, date, events) => Container(
//           margin: const EdgeInsets.all(4.0),
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: Color.fromARGB(255, 255, 187, 0),
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//           child: Text(
//             date.day.toString(),
//             style: TextStyle(color: Colors.white),
//           ),
//         ),
//       ),
//       headerStyle: HeaderStyle(
//         formatButtonVisible: false,
//         titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         leftChevronIcon: Icon(Icons.chevron_left),
//         rightChevronIcon: Icon(Icons.chevron_right),
//       ),
//       calendarStyle: CalendarStyle(
//         todayDecoration: BoxDecoration(
//           color: Color.fromARGB(255, 255, 240, 200),
//           shape: BoxShape.circle,
//         ),
//         selectedTextStyle: TextStyle(color: Colors.white),
//       ),
//     );
//   }
// }
