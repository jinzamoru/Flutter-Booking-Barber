// ignore_for_file: library_private_types_in_public_api

import 'package:finalprojectbarber/php_data/php_data.dart';
import 'package:finalprojectbarber/theme/extention.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data_manager/data_manager.dart';
import '../theme/light_color.dart';
import '../theme/text_styles.dart';
import '../widgets/dashboard/hair_list_widget.dart';
import '../widgets/hair_searching_screen.dart';
import 'hair_add_details_screen.dart';

class HairPage extends StatefulWidget {
  final String id;
  const HairPage({super.key, required this.id});

  @override
  _HairPageState createState() => _HairPageState();
}

class _HairPageState extends State<HairPage> {
  bool searchingStart = false;
  TextEditingController textController = TextEditingController();

  late String id = "";
  @override
  void initState() {
    super.initState();
    id = widget.id;
    textController.addListener(() {
      if (textController.text.isNotEmpty) {
        Provider.of<DataManagerProvider>(context, listen: false)
            .searchListhairs
            .clear();
        Provider.of<DataManagerProvider>(context, listen: false)
            .setIsSearching(true);
        Provider.of<DataManagerProvider>(context, listen: false)
            .getSearchHair(textController.text);
      } else {
        Provider.of<DataManagerProvider>(context, listen: false)
            .setIsSearching(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    getHairs(widget.id, context);
    return Scaffold(
      body: Consumer<DataManagerProvider>(
        builder: (context, providerData, child) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(
                          height: 40.0,
                        ),
                        Text(
                          "ทรงผม",
                          style: TextStyles.titleM.bold,
                        ),
                      ],
                    ).p16,
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
                          hintText: "ค้นหา ชื่อทรงผม...",
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
                    const SizedBox(height: 20), 
                  ],
                ),
              ),
              Provider.of<DataManagerProvider>(context).searchingStart
                  ? const HairSearchingScreen()
                  : hairsList(providerData.getAllHairs, context),
              const SliverToBoxAdapter(
                child: SizedBox(height: 80), 
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => HairAddDetailScreen(
                      id: widget.id,
                    )),
          );
        },
        backgroundColor: Colors.orange[300],
        child: const Icon(Icons.add),
      ),
    );
  }
}
