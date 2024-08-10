
import 'package:finalprojectbarber/widgets/hair_tile.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../data_manager/data_manager.dart';



class HairSearchingScreen extends StatelessWidget {
  const HairSearchingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Consumer<DataManagerProvider>(
            builder: (context, data, child){
              if(data.searchListhairs.isNotEmpty){
                return Column(
                    children: data.getSearchListhair.map((x) {
                   return hairTile(x , context);
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
