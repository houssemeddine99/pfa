import 'package:digital_sales_app/Models/Client.dart';

class User {
  String id;
  String firstname;
  String lastname;
  List<Client> clients;
  String email;
  String password;
  String tel;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.clients,
    required this.email,
    required this.password,
    required this.tel,
  });

  // Additional constructor
  User.basic({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
    required this.tel,
  }) : id = '', clients = [];

  // Factory method to create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      clients: (json['clients'] as List).map((e) => Client.fromJson(e)).toList(),
      email: json['email'],
      password: json['password'],
      tel: json['tel'],
    );
  }

  // Method to convert a User object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstname': firstname,
      'lastname': lastname,
      'clients': clients.map((e) => e.toJson()).toList(),
      'email': email,
      'password': password,
      'tel': tel,
    };
  }
}
