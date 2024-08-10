import 'package:finalprojectbarber/model/barber_model.dart';
import 'package:finalprojectbarber/theme/extention.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '../screen/customer_berber_workschedule.dart';
import '../theme/light_color.dart';
import '../theme/text_styles.dart';

Widget workScheduleTile(AllWorkScheduleModel model, BuildContext context) {
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
                "${model.barber.barberFirstName} ${model.barber.barberLastName}",
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
                            Icons.home,
                            size: 15,
                            color: Colors.black45,
                          ),
                          const SizedBox(width: 4.0),
                          SizedBox(
                            width: 200, 
                            child: Text(
                              "ที่อยู่ : ${model.barber.barberNamelocation}",
                              style: TextStyles.bodySm.subTitleColor.bold
                                  .copyWith(fontSize: 16.0),
                              overflow: TextOverflow.clip,
                            ),
                          )
                        ],
                      ),
                       Row(
                        children: [
                          const Icon(
                            Icons.query_builder,
                            size: 15,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 4.0),
                          SizedBox(
                            width: 200, 
                            child: Text(
                              "สถานะ : ว่าง ${model.total} คิว",
                              style: const TextStyle(color: Colors.green ,fontWeight: FontWeight.bold )
                                  .copyWith(fontSize: 16.0),
                              overflow: TextOverflow.clip,
                            ),
                          )
                        ],
                      ),
                    ],
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
                builder: (context) => BarberWorkschedule(id: model.barber.barberId, name: "${model.barber.barberFirstName} ${model.barber.barberLastName}",)));
      },
      borderRadius: const BorderRadius.all(Radius.circular(20)),
    ),
  );
}
