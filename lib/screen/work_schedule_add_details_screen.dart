// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:finalprojectbarber/php_data/php_data.dart';
import 'package:finalprojectbarber/theme/extention.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/k_components.dart';
import '../model/barber_model.dart';
import '../theme/light_color.dart';
import '../theme/text_styles.dart';
import '../theme/theme.dart';

class WorkScheduleAddDetailScreen extends StatefulWidget {
  final DateTime selectedDay;

  const WorkScheduleAddDetailScreen({
    super.key,
    required this.selectedDay,
  });

  @override
  _WorkScheduleAddDetailScreenState createState() =>
      _WorkScheduleAddDetailScreenState();
}

TextEditingController noteController = TextEditingController();
DateTime _startTime = DateTime.now();
DateTime _endTime = DateTime.now();
String year = '${DateTime.now().year + 543}';

class _WorkScheduleAddDetailScreenState
    extends State<WorkScheduleAddDetailScreen> {
  late DateTime day;
  @override
  void initState() {
    super.initState();
    _startTime = widget.selectedDay;
    _endTime = _startTime.add(const Duration(hours: 1));
  }

  Future<void> _pickTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(_startTime)
          : TimeOfDay.fromDateTime(_endTime),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            materialTapTargetSize: MaterialTapTargetSize.padded,
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              alwaysUse24HourFormat: true,
            ),
            child: child!,
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = DateTime(
            _startTime.year,
            _startTime.month,
            _startTime.day,
            picked.hour,
            picked.minute,
          );
          if (_startTime.isAfter(_endTime)) {
            _endTime = _startTime.add(const Duration(hours: 1));
          }
        } else {
          _endTime = DateTime(
            _endTime.year,
            _endTime.month,
            _endTime.day,
            picked.hour,
            picked.minute,
          );
          // ป้องกันให้ _endTime เกินเวลา _startTime
          if (_endTime.isBefore(_startTime)) {
            _startTime = _endTime.subtract(const Duration(hours: 1));
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = TextStyles.title.copyWith(fontSize: 25).bold;
    if (AppTheme.fullWidth(context) < 393) {
      titleStyle = TextStyles.title.copyWith(fontSize: 23).bold;
    }
    return Scaffold(
      backgroundColor: LightColor.extraLightBlue,
      body: Stack(
        children: <Widget>[
          DraggableScrollableSheet(
            maxChildSize: 1.0,
            minChildSize: 1.0,
            initialChildSize: 1.0,
            builder: (context, scrollController) {
              return Container(
                height: AppTheme.fullHeight(context) * .5,
                padding: const EdgeInsets.only(
                  left: 19,
                  right: 19,
                  top: 16,
                ), //symmetric(horizontal: 19, vertical: 16),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const BackButton(
                                color: Colors.black,
                              ),
                              Expanded(
                                child: Text(
                                  "ลงงาน",
                                  style:
                                      titleStyle.copyWith(color: Colors.black),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: .3,
                          color: LightColor.grey,
                        ),
                        Text(
                          'วันที่ : ${DateFormat.MMMMd('th-TH').format(_startTime)} $year',
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          'เวลาเริ่มต้นงาน: ${DateFormat('HH:mm').format(_startTime)}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {
                            _pickTime(context, true);
                          },
                          child: const Text('เวลาเริ่มต้นงาน'),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'เวลาสิ้นสุดงาน: ${DateFormat('HH:mm').format(_endTime)}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {
                            _pickTime(context, false);
                          },
                          child: const Text('เวลาสิ้นสุดงาน'),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            controller: noteController,
                            cursorColor: const Color(0xff8471FF),
                            style: const TextStyle(fontSize: 18.0),
                            decoration: kTextFormFieldDecoration.copyWith(
                              labelText: 'หมายเหตุ',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        MaterialButton(
                          elevation: 10.0,
                          onPressed: () async {
                            final model = WorkSchedule(
                                workScheduleID: '',
                                workScheduleStartDate: _startTime,
                                workScheduleEndDate: _endTime,
                                workScheduleNote: noteController.text,
                                workScheduleBarberID: '',
                                workScheduleStatus: 0);

                            if (await addWorkSchedule(model, context)) {
                              setState(() {
                                noteController.clear();
                                _startTime = widget.selectedDay;
                                _endTime =
                                    _startTime.add(const Duration(hours: 1));
                              });
                              Navigator.pop<bool>(context, true);
                            }
                          },
                          minWidth: double.infinity,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          color: const Color.fromARGB(255, 255, 183, 77),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            child: Text(
                              'ลงงาน',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20.0,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ).vP16),
              );
            },
          ),
        ],
      ),
    );
  }
}
