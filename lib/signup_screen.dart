import 'package:email_validator/email_validator.dart';
import 'package:finalprojectbarber/components/k_components.dart';
import 'package:finalprojectbarber/login.dart';
import 'package:finalprojectbarber/model/customer_model.dart';
import 'package:finalprojectbarber/php_data/php_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController rePasswordController = TextEditingController();

  late String roll;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * 1.0,
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  'assets/barber.png',
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width * 0.7,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  height: 60,
                  child: TextFormField(
                    controller: firstNameController,
                    cursorColor: const Color(0xff8471FF),
                    style: const TextStyle(fontSize: 18.0),
                    decoration: kTextFormFieldDecoration.copyWith(
                      labelText: 'ชื่อ',
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: TextFormField(
                    controller: lastNameController,
                    cursorColor: const Color(0xff8471FF),
                    style: const TextStyle(fontSize: 18.0),
                    decoration: kTextFormFieldDecoration.copyWith(
                      labelText: 'นามสกุล',
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: TextFormField(
                    controller: phoneController,
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    cursorColor: const Color(0xff8471FF),
                    style: const TextStyle(fontSize: 18.0),
                    decoration: kTextFormFieldDecoration.copyWith(
                        labelText: 'เบอร์โทรศัพท์'),
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: const Color(0xff8471FF),
                    style: const TextStyle(fontSize: 18.0),
                    decoration:
                        kTextFormFieldDecoration.copyWith(labelText: 'อีเมล'),
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: TextFormField(
                    controller: passwordController,
                    cursorColor: const Color(0xff8471FF),
                    style: const TextStyle(fontSize: 18.0),
                    obscureText: true,
                    decoration: kTextFormFieldDecoration.copyWith(
                      labelText: 'รหัสผ่าน',
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: TextFormField(
                    controller: rePasswordController,
                    cursorColor: Colors.white,
                    style: const TextStyle(fontSize: 18.0),
                    obscureText: true,
                    decoration: kTextFormFieldDecoration.copyWith(
                      labelText: 'รหัสผ่านอีกครั้ง',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                MaterialButton(
                  onPressed: () async {       
                    if (firstNameController.text.isEmpty ||
                        lastNameController.text.isEmpty ||
                        emailController.text.isEmpty ||
                        phoneController.text.isEmpty ||
                        passwordController.text.isEmpty || rePasswordController.text.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('ข้อผิดพลาด'),
                            content: const Text("กรุณากรอกข้อมูลให้ครบทุกช่อง"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('ตกลง'),
                              ),
                            ],
                          );
                        },
                      );
                      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      //     content: Text('Please fill all the fields')));
                    } else if (!EmailValidator.validate(emailController.text)) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('ข้อผิดพลาด'),
                            content: const Text("รูปแบบอีเมลไม่ถูกต้อง"),
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
                      if (passwordController.text !=
                          rePasswordController.text) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('ข้อผิดพลาด'),
                              content: const Text("รหัสผ่านไม่ตรงกัน"),
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
                        setState(() {
                          isLoading = true;
                        });
                        final userModel = CustomerInfo(
                            customerId: "",
                            customerFirstName: firstNameController.text,
                            customerLastName: lastNameController.text,
                            customerEmail: emailController.text,
                            customerPhone: phoneController.text,
                            customerPassword: rePasswordController.text);
                        addCustomerProfileData(userModel, context);
                        setState(() {
                          isLoading = false;
                        });
                      }
                    }
                  },
                  minWidth: double.infinity,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  color:  Colors.orangeAccent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            'Signup',
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 20.0,
                                color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have account? '),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.orangeAccent),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
