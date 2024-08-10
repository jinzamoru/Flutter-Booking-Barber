// ignore_for_file: library_private_types_in_public_api

import 'package:finalprojectbarber/php_data/php_data.dart';
import 'package:finalprojectbarber/theme/extention.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_manager/data_manager.dart';
import '../theme/text_styles.dart';
import '../widgets/dashboard/barber_booking_list_widget.dart';
// ignore: unused_import
import '../widgets/header.dart';

class BarberBookingPage extends StatefulWidget {
  final String id;

  const BarberBookingPage({
    super.key,
    required this.id,
  });

  @override
  _BarberBookingPageState createState() => _BarberBookingPageState();
}

class _BarberBookingPageState extends State<BarberBookingPage> {
  bool searchingStart = false;
  late String id;
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    id = widget.id;
    // textController.addListener(() {
    //   if (textController.text.isNotEmpty) {
    //     Provider.of<DataManagerProvider>(context, listen: false)
    //         .searchList
    //         .clear();
    //     Provider.of<DataManagerProvider>(context, listen: false)
    //         .setIsSearching(true);
    //     Provider.of<DataManagerProvider>(context, listen: false)
    //         .getSearch(textController.text);
    //   } else {
    //     Provider.of<DataManagerProvider>(context, listen: false)
    //         .setIsSearching(false);
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    getBarberBooking(id, context);
    return Scaffold(
      body: Consumer<DataManagerProvider>(
        builder: (context, providerData, child) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(
                          height: 30.0,
                        ),
                        Text(
                          "การจองคิว",
                          style: TextStyles.titleMedium,
                        ),
                      ],
                    ).p16,
                    // Container(
                    //   height: 55,
                    //   margin: const EdgeInsets.symmetric(
                    //       horizontal: 16, vertical: 10),
                    //   width: MediaQuery.of(context).size.width,
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius:
                    //         const BorderRadius.all(Radius.circular(13)),
                    //     boxShadow: <BoxShadow>[
                    //       BoxShadow(
                    //         color: LightColor.grey.withOpacity(.8),
                    //         blurRadius: 15,
                    //         offset: const Offset(5, 5),
                    //       )
                    //     ],
                    //   ),
                    //   child: TextField(
                    //     controller: textController,
                    //     onChanged: (value) {
                    //       // print(value);
                    //     },
                    //     decoration: InputDecoration(
                    //       contentPadding: const EdgeInsets.symmetric(
                    //           horizontal: 16, vertical: 16),
                    //       border: InputBorder.none,
                    //       hintText: "Search...",
                    //       hintStyle: TextStyles.body.subTitleColor,
                    //       suffixIcon: SizedBox(
                    //         width: 50,
                    //         child: const Icon(Icons.search,
                    //                 color: LightColor.purple)
                    //             .alignCenter
                    //             .ripple(
                    //               () {},
                    //               borderRadius: BorderRadius.circular(13),
                    //             ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              // Provider.of<DataManagerProvider>(context).searchingStart
              //     ? const WorkScheduleSearchingScreen()
              //     :
              BarberBookingList(providerData.getAllBarberBooking, context),
            ],
          );
        },
      ),
    );
  }
}
