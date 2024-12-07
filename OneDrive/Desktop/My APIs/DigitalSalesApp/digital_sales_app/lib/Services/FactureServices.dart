import 'dart:convert';

import 'package:digital_sales_app/Models/Facture.dart';
import 'package:digital_sales_app/Services/SecureStorage.dart';
import 'package:http/http.dart' as http;


import "../.env.dart";


Future<List<Facture>> getFactureByUser(String id, String token) async {
  try {
    final response = await http.get(
      Uri.parse('$apiUrl/factures/user/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> responseBody = jsonDecode(response.body);
      List<Facture> contracts = responseBody.map((item) => Facture.fromJson(item)).toList();
      return contracts;
    }         else if (response.statusCode == 401) {
        logout();
        throw Exception('Unauthorized: ${response.statusCode}');
        }else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to fetch data: $e');
  }


  
}

Future<Facture> createFacture(Facture facture, String token) async {
  try {
    final response = await http.post(
      Uri.parse('$apiUrl/factures'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(facture.toJson()),
    );

    if (response.statusCode == 201) {
      return Facture.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      logout();
      throw Exception('Unauthorized: ${response.statusCode}');
    } else {
      throw Exception('Failed to create facture: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to create facture: $e');
  }
}

Future<Facture> updateFacture(String id, Facture facture, String token) async {
  try {
    final response = await http.put(
      Uri.parse('$apiUrl/factures/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(facture.toJson()),
    );

    if (response.statusCode == 200) {
      return Facture.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      logout();
      throw Exception('Unauthorized: ${response.statusCode}');
    } else {
      throw Exception('Failed to update facture: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to update facture: $e');
  }
}

Future<void> deleteFacture(String id, String token) async {
  try {
    final response = await http.delete(
      Uri.parse('$apiUrl/factures/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 204) {
      return;
    } else if (response.statusCode == 401) {
      logout();
      throw Exception('Unauthorized: ${response.statusCode}');
    } else {
      throw Exception('Failed to delete facture: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to delete facture: $e');
  }
}

