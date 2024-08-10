// ignore_for_file: camel_case_types

import 'package:finalprojectbarber/widgets/barber_workschedule_tile.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../data_manager/data_manager.dart';



class BarberWorkScheduleSearchingScreen extends StatelessWidget {
  const BarberWorkScheduleSearchingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Consumer<DataManagerProvider>(
            builder: (context, data, child){
              if(data.searchListBarberWorkSchedule.isNotEmpty){
                return Column(
                    children: data.getSearchListBarberWorkSchedule.map((x) {
                   return barberWorkScheduleTile(x , context);
                    }).toList());
              }
              else{
                return const Align(
                    alignment: Alignment.topCenter,
                    child: Text('ไม่พบข้อมูล'));
              }

            },
          ),
        ]
      )
    );
  }
}
