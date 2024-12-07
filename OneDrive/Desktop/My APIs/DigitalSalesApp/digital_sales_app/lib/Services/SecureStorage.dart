import 'dart:convert';
import 'package:digital_sales_app/Pages/SignIn/SignInPage.dart';
import 'package:digital_sales_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


final storage = FlutterSecureStorage();


Future<String?> readToken() async {
  try {
    String? token = await storage.read(key: 'jwt_token');
    return token;;
  } catch (e) {
    print('Error reading JWT token: $e');
    return null;
  }
}

Future<void>saveClientID(String clientID) async {
  try {
    await storage.write(key: 'client_id', value: clientID);
  } catch (e) {
    print('Error saving client ID: $e');
  }
}

Future<void>saveUserID(String userID) async {
  try {
    await storage.write(key: 'user_id', value: userID);
  } catch (e) {
    print('Error saving user ID: $e');
  }
}


Future<String?> readUserID() async {
  try {
    String? userID = await storage.read(key: 'user_id');
    return userID;
  } catch (e) {
    print('Error reading user ID: $e');
    return null;
  } 
}

Future<void> saveUserFirstName(String firstName) async {
  try {
    await storage.write(key: 'user_first_name', value: firstName);
  } catch (e) {
    print('Error saving user first name: $e');
  }
}

Future<void> saveUserLastName(String lastName) async {
  try {
    await storage.write(key: 'user_last_name', value: lastName);
  } catch (e) {
    print('Error saving user last name: $e');
  }
}

Future<void> deleteUserNames() async {
  try {
    await storage.delete(key: 'user_first_name');
    await storage.delete(key: 'user_last_name');
  } catch (e) {
    print('Error deleting user names: $e');
  }
}

Future<String?> readUserFirstName() async {
  try {
    String? firstName = await storage.read(key: 'user_first_name');
    return firstName;
  } catch (e) {
    print('Error reading user first name: $e');
    return null;
  }
}

Future<void> saveUserEmail(String email) async {
  try {
    await storage.write(key: 'user_email', value: email);
  } catch (e) {
    print('Error saving user email: $e');
  }
}

Future<void> deleteUserEmail() async {
  try {
    await storage.delete(key: 'user_email');
  } catch (e) {
    print('Error deleting user email: $e');
  }
}

Future<String?> readUserEmail() async {
  try {
    String? email = await storage.read(key: 'user_email');
    return email;
  } catch (e) {
    print('Error reading user email: $e');
    return null;
  }
}
Future<String?> readUserLastName() async {
  try {
    String? lastName = await storage.read(key: 'user_last_name');
    return lastName;
  } catch (e) {
    print('Error reading user last name: $e');
    return null;
  }
}

Future<void> saveToken(String token) async {
  try {
    await storage.write(key: 'jwt_token', value: token);
  } catch (e) {
    print('Error saving JWT token: $e');
  }
}

Future<void> deleteToken() async {
  try {
    await storage.delete(key: 'jwt_token');
  } catch (e) {
    print('Error deleting JWT token: $e');
  }
}

Future<void> deleteClientID() async {
  try {
    await storage.delete(key: 'client_id');
  } catch (e) {
    print('Error deleting client ID: $e');
  }
}

Future<void> deleteUserID() async {
  try {
    await storage.delete(key: 'user_id');
  } catch (e) {
    print('Error deleting user ID: $e');
  }
}

void logout() {
  deleteToken();
  deleteClientID();
  deleteUserID();
  deleteUserNames();
  deleteUserEmail();
    navigatorKey.currentState?.popUntil((route) => route.isFirst);
            navigatorKey.currentState?.pushReplacement(
              MaterialPageRoute(builder: (context) => SignInPage()),
            );

  }