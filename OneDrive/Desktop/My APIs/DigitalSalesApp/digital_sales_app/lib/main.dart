import 'package:digital_sales_app/Pages/Home/HomePage.dart';
import 'package:digital_sales_app/Pages/SplashScreen.dart';
import 'package:flutter/material.dart';




final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'BasierCircle',
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF003366), // Set primary color
          secondary: Color(0xFFE7F1F9), // Set secondary color
          surface: Colors.white, // Set surface color
          error: Colors.red, // Set error color
          onPrimary: Color.fromARGB(255, 14, 13, 13), // Set text color on primary color
          onSecondary: Colors.white, // Set text color on secondary color
          onSurface: Colors.black, // Set text color on surface color
          onError: Colors.white, // Set text color on error color
          
        ),
        dialogBackgroundColor: Colors.white, // Set dialog background color
      ),
      debugShowCheckedModeBanner: false,
      home:  const SplashScreen(),
      routes: {
        '/Home': (context) =>  HomePage(),
      },
    );
  }
}