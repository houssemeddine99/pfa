
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:digital_sales_app/Pages/Home/HomePage.dart';
import 'package:digital_sales_app/Pages/SignIn/SignInPage.dart';
import 'package:digital_sales_app/Pages/SourcePage.dart';
import 'package:digital_sales_app/Services/SecureStorage.dart';
import 'package:flutter/material.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateUser();
  }

  Future<void> navigateUser() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You are in offline mode'),
          duration: Duration(seconds: 5),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BasePage(child: HomePage(),)),
      );
      return;
    }
    String? token = await readToken();
    if (token != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  BasePage(child: HomePage(),)),
        );
    } else {
      Navigator.pushAndRemoveUntil(
        context,

        
       MaterialPageRoute(builder: (context) => const SignInPage()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}