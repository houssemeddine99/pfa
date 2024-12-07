import 'dart:convert';
import 'package:digital_sales_app/.env.dart';
import 'package:digital_sales_app/Models/User.dart';
import 'package:digital_sales_app/Services/SecureStorage.dart';
import 'package:http/http.dart' as http;

import 'package:digital_sales_app/Models/Client.dart';

Future<User?> getUserByEmail(String email) async {
  final url = Uri.parse('$apiUrl/api/auth/user/$email');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    return User.fromJson(data);
  } else {
    print('Failed to load user');
    return null;
  }
}

Future<List<Client>?> getUserClientsByEmail(String email) async {
  User? user = await getUserByEmail(email);
  if (user != null) {
    return user.clients;
  } else {
    print('Failed to load user clients');
    return null;
  }
}

Future<String> addClient(String id,  String tel , String fname , String lastname) async {


final token = await readToken();
final body;
final url = Uri.parse('$apiUrl/users/$id/clients');
    Map<String, String> params;
       body = jsonEncode({
       'firstName': fname,
      'lastName': lastname,
      'tel': tel,
    });

    try {
    
      
      final response = await http.post(url, body: body, headers: {
        'Content-Type': 'application/json',
       'Authorization': 'Bearer $token',
      } );
      print('Server Response: ${response.statusCode}');
      if (response.statusCode == 200) {
    print("Success");

  return "ok";
      } else if (response.statusCode == 401) {
        logout();
        throw Exception('Unauthorized: ${response.statusCode}');
        } else {
       return response.body;
      }
    } catch (error) {
      print('Error posting contrat: $error');
      rethrow ;
    }
  }