// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:async';
import 'package:finalprojectbarber/customer_homepage.dart';
import 'package:finalprojectbarber/data_manager/data_manager.dart';
import 'package:finalprojectbarber/barber_homepage.dart';
import 'package:finalprojectbarber/php_data/php_data.dart';
import 'package:finalprojectbarber/select.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('th_TH', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return DataManagerProvider();
      },
      child: MaterialApp(
        title: "ProjectBarber",
        // --------------------- Add Theme Data ---------------------- //
        // Add theme data here
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: Colors.blueGrey[900],
          hintColor: Colors.cyan[600],

          // Define the default font family.

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: const TextTheme(
            displayLarge: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
            displayMedium: TextStyle(fontSize: 20.0, fontWeight: FontWeight.normal),
            titleLarge: TextStyle(fontSize: 20.0, fontStyle: FontStyle.normal),
            bodyMedium: TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  // -------------- for start page
  Widget defaultPage = Container();
  late SharedPreferences login;
  bool loginSuccess = false;
  late String roll;

  Future<void> checkIfAlreadyLogin() async {
    try {
      login = await SharedPreferences.getInstance();
      bool newUser = login.getBool('login') ?? true;
      if (!newUser) {
        setState(() {
          loginSuccess = true;
          roll = login.getString('roll').toString();
        });
        await loginUser(
          login.getString('email').toString(),
          login.getString('password').toString(),
          roll,
          context,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      // print('Error fetching shared preferences: $e');
      // Handle the error, such as showing an error dialog or retrying the operation.
    }
  }

//------------ check if the user is using app for first time or not
//   void checkSharedPrefs() async {
//     var sharedPrefs = await SharedPreferences.getInstance();
//     if (sharedPrefs.containsKey("firstTime")) {
//       defaultPage = Container();
//     }
//   }

//-------- initialize with a Timer that will push to new screen after few seconds
  @override
  void initState() {
    super.initState();
    checkIfAlreadyLogin();
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => loginSuccess
              ? roll == 'Customer'
                  ? const CustomerHomePage()
                  : const BarberHomePage()
              : SelectPage(),
        ),
      );
    });
  }

// ---------------- Splash Screen Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // -------------------- temp background color can be changed.... in THEME DATA
      backgroundColor: Colors.orange[200],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "assets/splash_screen.gif",
            height: (60 / 100) * MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          CircularProgressIndicator(
            strokeWidth: 4,
            backgroundColor: Colors.blue[200],
          )
        ],
      ),
    );
  }
}
