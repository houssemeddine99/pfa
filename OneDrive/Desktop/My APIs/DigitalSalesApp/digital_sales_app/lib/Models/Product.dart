

import 'package:digital_sales_app/Models/Category.dart';

class Product {
  String id;
  String name;
  String image;
  double price;
  int quantity;
  Category category;
  String idUser;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    required this.category,
    required this.idUser,
  });

  // Factory method to create a Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      price: json['price'],
      quantity: json['quantity'],
      category: Category.fromJson(json['category']),
      idUser: json['userId'],
    );
  }

  // Method to convert a Product object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'price': price,
      'quantity': quantity,
      'category': category.toJson(),
      'userId': idUser,
    };
  }
}
