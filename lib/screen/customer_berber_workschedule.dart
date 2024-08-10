// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'package:finalprojectbarber/php_data/php_data.dart';
import 'package:finalprojectbarber/theme/extention.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_manager/data_manager.dart';
import '../theme/light_color.dart';
import '../theme/text_styles.dart';
import '../widgets/barber_workschedule_searching_screen.dart';
import '../widgets/dashboard/barber_workschedule_list_widget.dart';

class BarberWorkschedule extends StatefulWidget {
  final String id;
  final String name;

  const BarberWorkschedule({super.key, required this.id, required this.name});

  @override
  _BarberWorkscheduleState createState() => _BarberWorkscheduleState();
}

class _BarberWorkscheduleState extends State<BarberWorkschedule> {
  bool searchingStart = false;

  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textController.addListener(() {
      if (textController.text.isNotEmpty) {
        Provider.of<DataManagerProvider>(context, listen: false)
            .searchListBarberWorkSchedule
            .clear();
        Provider.of<DataManagerProvider>(context, listen: false)
            .setIsSearching(true);
        Provider.of<DataManagerProvider>(context, listen: false)
            .getSearchBarberWorkSchedule(textController.text);
      } else {
        Provider.of<DataManagerProvider>(context, listen: false)
            .setIsSearching(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    getWorkSchedule(widget.id, context);
    return Scaffold(
      appBar: AppBar(
        title:  Text(widget.name),
      ),
      body: Consumer<DataManagerProvider>(
        builder: (context, providerData, child) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [                 
                    Container(
                      height: 55,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(13)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: LightColor.grey.withOpacity(.8),
                            blurRadius: 15,
                            offset: const Offset(5, 5),
                          )
                        ],
                      ),
                      child: TextField(
                        controller: textController,
                        onChanged: (value) {
                          // print(value);
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          border: InputBorder.none,
                          hintText: "ค้นหา วันที่...",
                          hintStyle: TextStyles.body.subTitleColor,
                          suffixIcon: SizedBox(
                            width: 50,
                            child: const Icon(Icons.search,
                                    color: Colors.orangeAccent)
                                .alignCenter
                                .ripple(
                                  () {},
                                  borderRadius: BorderRadius.circular(13),
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Provider.of<DataManagerProvider>(context).searchingStart
                  ? const BarberWorkScheduleSearchingScreen()
                  : barberWorkScheduleList(
                      providerData.getBarberWorkSchedule, context),
            ],
          );
        },
      ),
    );
  }
}
