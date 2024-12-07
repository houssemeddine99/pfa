import 'dart:convert';

import 'package:digital_sales_app/Pages/Home/HomePage.dart';
import 'package:digital_sales_app/Pages/SourcePage.dart';
import 'package:digital_sales_app/Services/SecureStorage.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import '../../.env.dart';
import '../../Widgets/DialogAlert.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _EmailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isButtonDisabled = false;


  Future<void> _signIn() async {


    if (_formKey.currentState!.validate()) {
      setState(() {
        _isButtonDisabled = true; // Disable the button
      });

      final user = {
        'email': _EmailController.text,
        'password': _passwordController.text,
      };
      try {
        final response = await http.post(
          Uri.parse('$apiUrl/api/auth/signin'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(user),
        );

        if (response.statusCode == 200) {
          final responseBody = jsonDecode(response.body);
          print(responseBody);
          final token = responseBody['accessToken'];
          await saveToken(token);
          await saveUserID(responseBody['id']);
          await saveUserFirstName(responseBody['firstname']);
          await saveUserLastName(responseBody['lastname']);
          await saveUserEmail(responseBody["email"]);
          setState(() {
            _isButtonDisabled = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Signed in successfully"),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) =>  BasePage(child: HomePage(),)),
          );
        } else {
          final responseBody = jsonDecode(response.body);
          final errorMessage = responseBody['msg'];
          showAlert(
            context,
            title: 'Oops!',
            type: AlertType.error,
            message: "Failed to sign in"+(errorMessage ?? 'Unknown error'),
          );
          setState(() {
            _isButtonDisabled = false;
          });
        }
      } catch (e) {
        // Handle exceptions
        print('Error signing in: $e');
        setState(() {
          _isButtonDisabled = false; 
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F1F3),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 100,
              child: Text(
                "Sign In",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Roboto',
                  letterSpacing: 2,
                  fontSize: 48.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              "Start Your Journey with affordable price",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Roboto',
                fontSize: 14.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        toolbarHeight: 250,
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(25.0, 8.0, 25.0, 0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Text(
                  "Email",
                  style: TextStyle(
                    color: Color(0xFF808080),
                    fontFamily: 'Roboto',
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                TextFormField(
                  controller: _EmailController,
                  cursorColor: const Color(0xFF042F40),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    letterSpacing: 1,
                    color: Color(0xFF042F40),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Email';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Enter your Email',
                    hintStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 1,
                      color: Color(0xFF042F40),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF042F40)),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "Password",
                  style: TextStyle(
                    color: Color(0xFF808080),
                    fontFamily: 'Roboto',
                    fontSize: 14.0,
                    letterSpacing: 1,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  cursorColor: const Color(0xFF042F40),
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 18.0,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF042F40),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Enter your password',
                    hintStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 1,
                      color: Color(0xFF042F40),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF042F40)),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: _isButtonDisabled
                              ? MaterialStateProperty.all<Color>(
                                  Theme.of(context).colorScheme.primary)
                              : MaterialStateProperty.all<Color>(
                                 Theme.of(context).colorScheme.primary,),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        onPressed: _isButtonDisabled ? null : _signIn,
                        child: _isButtonDisabled
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Sign In'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Center(child: const Text("Or Sign In With")),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      iconSize: 35,
                      icon: const FaIcon(FontAwesomeIcons.google),
                      onPressed: () {},
                    ),
                    IconButton(
                      iconSize: 35,
                      icon: const FaIcon(FontAwesomeIcons.facebook),
                      onPressed: () {},
                    ),
                    IconButton(
                      iconSize: 35,
                      icon: const FaIcon(FontAwesomeIcons.apple),
                      onPressed: () {},
                    ),
                  ],
                ),
                /*Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don’t Have an Account? "),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/Signup');
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Color(0xFF0064D2),
                          fontFamily: 'Roboto',
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }


}