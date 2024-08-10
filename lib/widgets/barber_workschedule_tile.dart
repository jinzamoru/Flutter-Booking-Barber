import 'package:finalprojectbarber/model/barber_model.dart';
import 'package:finalprojectbarber/screen/workschedule_details_screen.dart';
import 'package:finalprojectbarber/theme/extention.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '../theme/light_color.dart';
import '../theme/text_styles.dart';

Widget barberWorkScheduleTile(WorkScheduleModel model, BuildContext context) {
  Intl.defaultLocale = 'th_TH';
  initializeDateFormatting(Intl.defaultLocale);
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      boxShadow: <BoxShadow>[
        const BoxShadow(
          offset: Offset(4, 4),
          blurRadius: 10,
          color: Colors.black26,
        ),
        BoxShadow(
          offset: const Offset(-3, 0),
          blurRadius: 15,
          color: LightColor.grey.withOpacity(.1),
        )
      ],
    ),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              title: Text(
                "วันที่ ${DateFormat.MMMMd('th-TH').format(model.workSchedule.workScheduleStartDate)}",
                style: TextStyles.titleM.bold
                    .copyWith(color: Colors.black, fontSize: 18.0),
              ),
              subtitle: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [           
                      Row(
                        children: [
                          const Icon(
                            Icons.timer_rounded,
                            size: 15,
                            color: Colors.black45,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            "เวลา ${DateFormat('HH:mm').format(model.workSchedule.workScheduleStartDate)} น. - ${DateFormat('HH:mm').format(model.workSchedule.workScheduleEndDate)} น.",
                            style: TextStyles.bodySm.subTitleColor.bold
                                .copyWith(fontSize: 16.0),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.home,
                            size: 15,
                            color: Colors.black45,
                          ),
                          const SizedBox(width: 4.0),
                          SizedBox(
                            width: 200, 
                            child: Text(
                              "ที่อยู่ ${model.barber.barberNamelocation}",
                              style: TextStyles.bodySm.subTitleColor.bold
                                  .copyWith(fontSize: 16.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                    "ว่าง",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: model.workSchedule.workScheduleStatus == 0
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              trailing: Icon(
                Icons.keyboard_arrow_right,
                size: 30,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    ).ripple(
      () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => WorkScheduleDetailScreen(model: model)));
      },
      borderRadius: const BorderRadius.all(Radius.circular(20)),
    ),
  );
}
