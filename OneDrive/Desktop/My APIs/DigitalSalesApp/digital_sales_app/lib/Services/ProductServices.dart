import 'dart:convert';
import 'package:digital_sales_app/.env.dart';
import 'package:digital_sales_app/Models/Category.dart';
import 'package:digital_sales_app/Models/Product.dart';
import 'package:digital_sales_app/Services/SecureStorage.dart';
import 'package:http/http.dart' as http;

Future<bool> updateProduct(Product product, String token) async {
  try {
    final response = await http.put(
      Uri.parse('$apiUrl/products/update/${product.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(product.toJson()),
    );
    print(response.statusCode);
    if (response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 401) {
      logout();
      throw Exception('Unauthorized: ${response.statusCode}');
    } else if (response.statusCode == 400) {
      throw Exception('Bad Request: ${response.body}');
    } else {
      throw Exception('Failed to update product: ${response.statusCode}');
    }
  } on FormatException catch (e) {
    throw Exception('Failed to update product: FormatException: $e');
  } catch (e) {
    throw Exception('Failed to update product: $e');
  }
}


Future<List<Product>> getProductsByUserId(String userId, String token) async {
  try {
    final response = await http.get(
      Uri.parse('$apiUrl/products/get-by-user/$userId'),
      headers: {
          'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
      return [];
      }
       
      List<dynamic> responseBody = jsonDecode(response.body);
      List<Product> products = responseBody.map((item) => Product.fromJson(item)).toList();
     
      return products;
    } else if (response.statusCode == 401) {
      logout();
      throw Exception('Unauthorized: ${response.statusCode}');
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode} ');
    }
    } on FormatException catch (e) {
    throw Exception('Failed to fetch data: FormatException: $e');
    } catch (e) {
    throw Exception('Failed to fetch data: $e');
    }
  }

  Future<bool> deleteProducts(List<String> productIds, String token) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/products/delete-multiple'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(productIds),
      );
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        logout();
        throw Exception('Unauthorized: ${response.statusCode}');
      } else {
        throw Exception('Failed to delete products: ${response.statusCode}');
      }
    } on FormatException catch (e) {
      throw Exception('Failed to delete products: FormatException: $e');
    } catch (e) {
      throw Exception('Failed to delete products: $e');
    }
  }

  Future<bool> addProduct(Product product, String token) async {
    try {
    final response = await http.post(
      Uri.parse('$apiUrl/products/add'),
      headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      },
      body: jsonEncode(product.toJson()),
    );
  print(response.statusCode);
    if (response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 401) {
      logout();
      throw Exception('Unauthorized: ${response.statusCode}');
    } else if (response.statusCode == 400) {
      throw Exception('Bad Request: ${response.body}');
    } else {
      throw Exception('Failed to add product: ${response.statusCode}');
    }
    } on FormatException catch (e) {
    throw Exception('Failed to add product: FormatException: $e');
    } catch (e) {
    throw Exception('Failed to add product: $e');
    }
  }

Future<List<Category>> getCategorysByUserId(String userId, String token) async {
  try {
    final response = await http.get(
      Uri.parse('$apiUrl/categories/user/$userId'),
      headers: {
          'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        return [];
      }
       
      List<dynamic> responseBody = jsonDecode(response.body);
      List<Category> categories = responseBody.map((item) => Category.fromJson(item)).toList();
     
      return categories;
    } else if (response.statusCode == 401) {
        logout();
        throw Exception('Unauthorized: ${response.statusCode}');
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode} ');
    }
  } on FormatException catch (e) {
    throw Exception('Failed to fetch data: FormatException: $e');
  } catch (e) {
    throw Exception('Failed to fetch data: $e');
  }
}

Future<String> addCategory(String userId, String categoryName, String token) async {
  try {
    final response = await http.post(
      Uri.parse('$apiUrl/categories/add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'userId': userId,
        'name': categoryName,
      }),
    );

    if (response.statusCode == 201) {
      return 'ok';
    } else if (response.statusCode == 401) {
      logout();
      throw Exception('Unauthorized: ${response.statusCode}');
    } else if (response.statusCode == 400) {
      throw Exception('Bad Request: ${response.body}');
    } else {
      throw Exception('Failed to add category: ${response.statusCode}');
    }
  } on FormatException catch (e) {
    throw Exception('Failed to add category: FormatException: $e');
  } catch (e) {
    throw Exception('Failed to add category: $e');
  }

    
}