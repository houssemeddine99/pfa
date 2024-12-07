import 'package:digital_sales_app/Pages/Home/HomePage.dart';
import 'package:digital_sales_app/Pages/SourcePage.dart';
import 'package:digital_sales_app/Services/SecureStorage.dart';
import 'package:digital_sales_app/Services/UserServices.dart';
import 'package:digital_sales_app/Widgets/AddClientWidget.dart';
import 'package:flutter/material.dart';

import 'package:digital_sales_app/Models/Client.dart';
import 'package:url_launcher/url_launcher.dart';

class MyClientsPage extends StatefulWidget {
  @override
  _MyClientsPageState createState() => _MyClientsPageState();
}

class _MyClientsPageState extends State<MyClientsPage> {
  List<Client> clients = [];
  List<Client> filteredClients = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchClients();
  }

  Future<void> fetchClients() async {
    String? email = await readUserEmail();
    final fetchedClients = await getUserClientsByEmail(email!);
    setState(() {
      if (fetchedClients != null) {
        clients = fetchedClients;
        filteredClients = fetchedClients;
      }
      isLoading = false;
    });
  }

  void _addClient() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddClientWidget();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => BasePage(
                        child: HomePage(),
                      )),
            );
          },
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('Mes Clients', style: TextStyle(color: Colors.white)),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : clients.isEmpty
              ? Center(child: Text('Aucun client disponible'))
              : Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ListView.builder(
                    itemCount: filteredClients.length,
                    itemBuilder: (context, index) {
                      final client = filteredClients[index];
                      return Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        elevation: 5,
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(client.firstName[0]),
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                          ),
                          title: Text(
                            '${client.firstName} ${client.lastName}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(client.tel),
                            trailing: IconButton(
                            icon: Icon(Icons.phone, color: Colors.teal),
                            onPressed: () {
                              launchUrl(Uri.parse('tel:${client.tel}'));
                            },
                            ),
                        ),
                      );
                    },
                  ),
              ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: !isLoading && clients.isEmpty
          ? FloatingActionButton(
              onPressed: _addClient,
              child:
                  Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
              backgroundColor: Colors.white,
            )
          : null,
      bottomNavigationBar: clients.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          filteredClients = clients.where((client) {
                            final clientName =
                                '${client.firstName} ${client.lastName}'
                                    .toLowerCase();
                            final clientPhone = client.tel.toLowerCase();
                            final searchLower = value.toLowerCase();
                            return clientName.contains(searchLower) ||
                                clientPhone.contains(searchLower);
                          }).toList();
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Rechercher',
                        hintText: 'Nom ou numéro de téléphone',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  FloatingActionButton(
                    onPressed: _addClient,
                    child: Icon(Icons.add,
                        color: Theme.of(context).colorScheme.primary),
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
