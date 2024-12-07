import 'package:digital_sales_app/Pages/ContratList/ContractListPage.dart';
import 'package:digital_sales_app/Pages/ClientsList/MyClientsPage.dart';
import 'package:digital_sales_app/Services/SecureStorage.dart';
import 'package:flutter/material.dart';

class BasePage extends StatefulWidget {
  final Widget child;

  BasePage({required this.child});

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  String firstName = '';
  String lastName = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    String? fName = await readUserFirstName();
    String? lName = await readUserLastName();
    setState(() {
      firstName = fName ?? '';
      lastName = lName ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Digital Sales"), ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                image: DecorationImage(
                  image: AssetImage('assets/background.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${firstName.isNotEmpty ? firstName[0].toUpperCase() + firstName.substring(1) : ''} ${lastName.isNotEmpty ? lastName[0].toUpperCase() + lastName.substring(1) : ''}',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text("Home"),
              leading: Icon(Icons.home),  
              onTap: () {},
            ),
            ListTile(
              title: Text("Profile"),
              leading: Icon(Icons.person),
              onTap: () {},
            ),
                 ListTile(
              title: Text("Mes Contrats"),
              leading: Icon(Icons.insert_drive_file_rounded),
              onTap: () {
                           Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContactListPage()),
                  );
              },
            ),
               ListTile(
              title: Text("Mes Clients"),
              leading: Icon(Icons.person_pin_rounded),
              onTap: () {
                           Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyClientsPage()),
                  );
              },
            ),
            ListTile(
              title: Text("Settings"),
              leading: Icon(Icons.settings),
              onTap: () {},
            ),

            Divider(color: Colors.black),
            ListTile(
              title: Text("Logout"),
              leading: Icon(Icons.logout),
              onTap: () {
                logout();
              },
            )
          ],
        ),
      ),
      body: widget.child,
    );
  }
}