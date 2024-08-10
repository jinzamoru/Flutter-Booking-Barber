import 'package:finalprojectbarber/model/customer_model.dart';
import 'package:finalprojectbarber/screen/location_screen.dart';
import 'package:finalprojectbarber/select.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data_manager/data_manager.dart';

import '../theme/light_color.dart';
import '../widgets/logout.dart';
import 'customer_edit_profile_screen.dart';

class CustomerProfileScreen extends StatelessWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Consumer<DataManagerProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(255, 255, 167, 38),
                      Color.fromARGB(255, 255, 243, 224),
                    ],
                  )),
                  child: Column(
                  
                    children: [
                      const SizedBox(height: 40),
                      // const CircleAvatar(
                      //   radius: 60.0,
                      //   backgroundColor: Colors.deepPurpleAccent,
                      //   // backgroundImage: AssetImage("assets/user.jpg"),
                      // ),
                      Text(
                        "${provider.customerProfile.customerFirstName} ${provider.customerProfile.customerLastName}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        "ลูกค้า",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 5),
                              color: Colors.deepOrange.withOpacity(.2),
                              spreadRadius: 2,
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 5.0),
                            ListTile(
                              title: const Text('ชื่อ'),
                              subtitle: Text(
                                  "${provider.customerProfile.customerFirstName} ${provider.customerProfile.customerLastName}"),
                              leading: const Icon(Icons.person),
                              tileColor: Colors.white,
                            ),
                            const Divider(
                              thickness: .3,
                              color: LightColor.grey,
                            ),
                            ListTile(
                              title: const Text('เบอร์โทรศัพท์'),
                              subtitle:
                                  Text(provider.customerProfile.customerPhone),
                              leading: const Icon(Icons.phone_android),
                              tileColor: Colors.white,
                            ),
                            const Divider(
                              thickness: .3,
                              color: LightColor.grey,
                            ),
                            ListTile(
                              title: const Text('อีเมล'),
                              subtitle:
                                  Text(provider.customerProfile.customerEmail),
                              leading: const Icon(Icons.email),
                              tileColor: Colors.white,
                            ),
                            const Divider(
                              thickness: .3,
                              color: LightColor.grey,
                            ),
                            ListTile(
                              title: const Text('ที่อยู่ของฉัน'),
                              leading: const Icon(Icons.home),
                              onTap: () => {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => const LocationPage(),
                                  ),
                                )
                              },
                              trailing: const Icon(Icons.arrow_forward,
                                  color: Colors.grey),
                              tileColor: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      MaterialButton(
                        onPressed: () {
                          final customerModel = CustomerInfo(
                            customerId: provider.customerProfile.customerId,
                            customerFirstName:
                                provider.customerProfile.customerFirstName,
                            customerLastName:
                                provider.customerProfile.customerLastName,
                            customerPhone:
                                provider.customerProfile.customerPhone,
                            customerEmail:
                                provider.customerProfile.customerEmail,
                            customerPassword: "",
                          );
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => CustomerEditProfileScreen(
                                  model: customerModel),
                            ),
                          );
                        },
                        color: Colors.orange,
                        child: const Text(
                          'แก้ไขบัญชี',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          Logout().accountLogout().whenComplete(() {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => SelectPage()),
                                (Route<dynamic> route) => false);
                          });
                        },
                        color: Colors.orange,
                        child: const Text(
                          'ออกจากระบบ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
