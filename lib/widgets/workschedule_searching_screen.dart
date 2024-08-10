// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../data_manager/data_manager.dart';
import 'workschedule_tile.dart';



class WorkScheduleSearchingScreen extends StatelessWidget {
  const WorkScheduleSearchingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Consumer<DataManagerProvider>(
            builder: (context, data, child){
              if(data.searchListWorkSchedule.isNotEmpty){
                return Column(
                    children: data.getSearchListWorkSchedule.map((x) {
                   return workScheduleTile(x , context);
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
