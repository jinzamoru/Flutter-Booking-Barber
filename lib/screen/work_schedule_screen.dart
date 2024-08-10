// ignore_for_file: library_private_types_in_public_api

import 'dart:collection';
import 'dart:convert';

import 'package:finalprojectbarber/php_data/php_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../data_manager/data_manager.dart';
import '../model/barber_model.dart';
import '../widgets/event_item.dart';
import 'work_schedule_add_details_screen.dart';

class WorkSchedulePage extends StatefulWidget {
  final String id;
  const WorkSchedulePage({
    super.key,
    required this.id,
  });

  @override
  _WorkSchedulePageState createState() => _WorkSchedulePageState();
}

class _WorkSchedulePageState extends State<WorkSchedulePage> {
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late DateTime _selectedDay;
  late CalendarFormat _calendarFormat;
  late Map<DateTime, List<WorkSchedule>> _events;

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  String year = '${DateTime.now().year + 543}';

  @override
  void initState() {
    super.initState();
    _events = LinkedHashMap(
      equals: isSameDay,
      hashCode: getHashCode,
    );
    _focusedDay = DateTime.now();
    _firstDay = DateTime.now().subtract(const Duration(days: 1000));
    _lastDay = DateTime.now().add(const Duration(days: 1000));
    _selectedDay = DateTime.now();
    _calendarFormat = CalendarFormat.month;
    final String userId = widget.id;
    _initializeEvents(userId);
  }

  _initializeEvents(String id) async {
    _events = {};
    try {
      final url = Uri.parse('$server/get_workSchedule.php/?id=$id');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['result'] == 1) {
          var workScheduleData = data['data'];
          if (workScheduleData is List) {
            for (var workSchedule in workScheduleData) {
              final event = WorkSchedule(
                workScheduleID: workSchedule['id'].toString(),
                workScheduleStartDate:
                    DateTime.parse(workSchedule['startdate']),
                workScheduleEndDate: DateTime.parse(workSchedule['enddate']),
                workScheduleNote: workSchedule['note'].toString(),
                workScheduleBarberID: workSchedule['ba_id'].toString(),
                workScheduleStatus: workSchedule['status'] as int,
              );
              final day = DateTime.utc(
                  event.workScheduleStartDate.year,
                  event.workScheduleStartDate.month,
                  event.workScheduleStartDate.day);
              if (_events[day] == null) {
                _events[day] = [];
              }
              _events[day]!.add(event);
            }
            if (mounted) {
              setState(() {});
            }
          }
        }
      }
    } catch (e) {
      // print("Error: $e");
    }
  }

  List<WorkSchedule> _getEventsForTheDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    String id = Provider.of<DataManagerProvider>(context, listen: false)
        .barberProfile
        .barberId;
    return Scaffold(
      appBar: AppBar(title: const Text('ตารางงาน')),
      body: ListView(
        children: [
          TableCalendar(
            locale: 'th-TH',
            headerStyle: HeaderStyle(
              titleTextStyle: const TextStyle(fontSize: 18),
              titleTextFormatter: (date, locale) =>
                  '${DateFormat.MMMMd(locale).format(date)} $year',
            ),
            eventLoader: _getEventsForTheDay,
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            focusedDay: _focusedDay,
            firstDay: _firstDay,
            lastDay: _lastDay,
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
                year = '${(focusedDay.year + 543)}';
              });
              // _initializeEvents(id);
            },
            selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              // print(_events[selectedDay]);
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: const CalendarStyle(
              weekendTextStyle: TextStyle(
                color: Colors.red,
              ),
              selectedDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 251, 201, 125),
              ),
              todayDecoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 224, 178),
                shape: BoxShape.circle,
              ),             
            ),
            // calendarBuilders: CalendarBuilders(
            // headerTitleBuilder: (context, day) {
            //   return Container(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Text(day.toString()),
            //   );
            // },
            // ),
          ),
          ..._getEventsForTheDay(_selectedDay).map(
            (event) => EventItem(
                event: event,
                // onTap: () async {
                //   final res = await Navigator.push<bool>(
                //     context,
                //     MaterialPageRoute(
                //       builder: (_) => BarberProfileScreen(),
                //     ),
                //   );
                //   if (res ?? false) {
                //     _initializeEvents(id);
                //   }
                // },
                onDelete: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('ลบข้อมูล'),
                        content: const Text('ต้องการลบข้อมูลนี้หรือไม่?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('ยกเลิก'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await deleteWorkSchedule(
                                  event.workScheduleID, context);
                              _initializeEvents(id);
                            },
                            child: const Text('ลบ'),
                          ),
                        ],
                      );
                    },
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => WorkScheduleAddDetailScreen(
                selectedDay: _selectedDay,
              ),
            ),
          );
          if (result ?? false) {
            _initializeEvents(id);
          }
        },
        backgroundColor: Colors.orange[300],
        child: const Icon(Icons.add),
      ),
    );
  }
}
