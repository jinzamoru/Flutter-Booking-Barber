// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:finalprojectbarber/model/hair_model.dart';
import 'package:finalprojectbarber/theme/extention.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../components/k_components.dart';
import '../php_data/php_data.dart';
import '../theme/light_color.dart';
import '../theme/text_styles.dart';
import '../theme/theme.dart';

class HairDetailScreen extends StatefulWidget {
  final HairModel model;

  const HairDetailScreen({
    super.key,
    required this.model,
  });

  @override
  _HairDetailScreenState createState() => _HairDetailScreenState();
}

class _HairDetailScreenState extends State<HairDetailScreen> {
  late HairModel model;
  late String photo;
  File? _imageFile;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  @override
  void initState() {
    model = widget.model;

    super.initState();

    nameController.text = model.hairName;
    priceController.text = model.hairPrice.toString();
    photo = model.hairPhoto.toString();
  }

  Future<File?> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
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
                                  "แก้ไขทรงผม",
                                  style:
                                      titleStyle.copyWith(color: Colors.black),
                                ),
                              ),                          
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: .3,
                          color: LightColor.grey,
                        ),
                        Container(
                          height: 45,
                          alignment: Alignment.centerLeft,
                          child: const Text("รูปทรงผม"),
                        ),
                        InkResponse(
                          onTap: () async {
                            File? imageFile =
                                await pickImage(ImageSource.gallery);
                            if (imageFile == null) return;
                            setState(() {
                              _imageFile = imageFile;
                            });
                          },
                          child: Container(
                              height: 250,
                              width: 350,
                              decoration: ShapeDecoration(
                                color: Colors.grey[300],
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                              ),
                              child: _imageFile == null
                                  ? Image.network(
                                      "$server/hair/${model.hairPhoto}")
                                  : Image.file(_imageFile!)),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            controller: nameController,
                            cursorColor: const Color(0xff8471FF),
                            style: const TextStyle(fontSize: 18.0),
                            decoration: kTextFormFieldDecoration.copyWith(
                              labelText: 'ชื่อทรงผม',
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            controller: priceController,
                            cursorColor: const Color(0xff8471FF),
                            style: const TextStyle(fontSize: 18.0),
                            decoration: kTextFormFieldDecoration.copyWith(
                              labelText: 'ราคา',
                            ),
                          ),
                        ),
                         MaterialButton(
                          elevation: 10.0,
                          onPressed: () async {
                            if (nameController.text.isEmpty ||
                                priceController.text.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('ข้อผิดพลาด'),
                                    content:
                                        const Text("กรุณากรอกข้อมูลให้ครบทุกช่อง"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('ตกลง'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              final hairModel = HairModel(
                                hairId: model.hairId,
                                hairName: nameController.text,
                                hairPrice: int.parse(priceController.text),
                                hairPhoto: model.hairPhoto,
                                barberId: model.barberId,
                              );
                              updateHair(hairModel, context, _imageFile);
                            }
                          },
                          minWidth: double.infinity,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          color: const Color.fromARGB(255, 255, 183, 77),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.edit_square, color: Colors.white),
                                Text(
                                  ' แก้ไข',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20.0,
                                      color: Colors.white),
                                ),
                              ],
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
