
import 'package:digital_sales_app/Models/Facture.dart';
import 'package:digital_sales_app/Services/FactureServices.dart';
import 'package:digital_sales_app/Services/SecureStorage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContactListPage extends StatefulWidget {
  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  List<Facture> factures = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadContracts();
  }

  Future<void> loadContracts() async {
    try {
      String? clientID = await readUserID();
      String? token = await readToken();
      final List<Facture> factures1 = await getFactureByUser(clientID!, token!);
      setState(() {
        factures = factures1;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading contracts: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('Contract List', style: TextStyle(color: Colors.white)),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : factures.isNotEmpty ?
           Container(
              margin: EdgeInsets.symmetric(vertical: 0.0),
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: factures.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                     /* Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ContratDetailsPage(contrat: factures[index]),
                        ),
                      ); */
                    },
                    child: Container(
                      width: 110.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.cyan[50],
                          elevation: 8.0,
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    'Numero contract: ${factures[index].id}',
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.person, size: 20),
                                      SizedBox(width: 5),
                                      Text(
                                        'Conducteur 1: ${factures[index].id ?? 'Unknown'}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                if (factures[index].date != null)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.person_outline, size: 20),
                                        SizedBox(width: 5),
                                        Text(
                                          'Conducteur 2: ${factures[index].date?? 'Unknown'}',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.directions_car, size: 20),
                                      SizedBox(width: 5),
                                      Text(
                                        'Véhicule: ${factures[index].id}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              /*  Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_today, size: 20),
                                      SizedBox(width: 5),
                                      Text(
                                        'Date départ: ${factures[index].clientID != null ? DateFormat('yyyy-MM-dd HH:mm').format(contacts[index].dateDepart) : 'Unknown'}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.calendar_today_outlined, size: 20),
                                      SizedBox(width: 5),
                                      Text(
                                        'Date retour: ${contacts[index].dateRetour != null ? DateFormat('yyyy-MM-dd HH:mm').format(contacts[index].dateRetour) : 'Unknown'}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.attach_money, size: 20),
                                      SizedBox(width: 5),
                                      Text(
                                        'Total TTC: ${contacts[index].totalTTc} DT',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ), */
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
            : factures.isNotEmpty
                  ? Container(
                    margin: EdgeInsets.symmetric(vertical: 0.0),
                    child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: factures.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                      onTap: () {
                       /* Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ContratDetailsPage(contrat: contacts[index]),
                        ),
                        ); */
                      },
                      child: Container(
                        width: 110.0,
                        child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        child: Card(
                         
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.cyan[50],
                          elevation: 8.0,
                          child: Center(
                          child: Column(
                            children: <Widget>[
                            Padding( 
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                              'Numero contract: ${factures[index].id}',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                              'Nombre de jours : ${factures[index].userID}',
                              style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0 ),
                              child: Row(
                              children: [
                                Icon(Icons.person, size: 20),
                                SizedBox(width: 5),
                                Text(
                                'Conducteur 1: ${factures[index].id?? 'Unknown'}',
                                style: TextStyle(fontSize: 16),
                                ),
                              ],
                              ),
                            ),
                            if (factures[index].id != null)
                              Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                children: [
                                Icon(Icons.person_outline, size: 20),
                                SizedBox(width: 5),
                                Text(
                                  'Conducteur 2: ${factures[index].id?? 'Unknown'}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                ],
                              ),
                              ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                              children: [
                                Icon(Icons.directions_car, size: 20),
                                SizedBox(width: 5),
                                Text(
                                'Véhicule: ${factures[index].id}',
                                style: TextStyle(fontSize: 16),
                                ),
                              ],
                              ),
                            ),
                          /*  Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                              children: [
                                Icon(Icons.calendar_today, size: 20),
                                SizedBox(width: 5),
                                Text(
                                'Date départ: ${factures[index].id != null ? DateFormat('yyyy-MM-dd HH:mm').format(contacts[index].dateDepart) : 'Unknown'}',
                                style: TextStyle(fontSize: 16),
                                ),
                              ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                              children: [
                                Icon(Icons.calendar_today_outlined, size: 20),
                                SizedBox(width: 5),
                                Text(
                                'Date retour: ${contacts[index].dateRetour != null ? DateFormat('yyyy-MM-dd HH:mm').format(contacts[index].dateRetour) : 'Unknown'}',
                                style: TextStyle(fontSize: 16),
                                ),
                              ],
                              ),
                            ), */
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                              children: [
                                Icon(Icons.attach_money, size: 20),
                                SizedBox(width: 5),
                                Text(
                                'Total TTC: ${factures[index].totalAmount} DT',
                                style: TextStyle(fontSize: 16),
                                ),
                              ],
                              ),
                            ),
                            ],
                          ),
                          ),
                        ),
                        ),
                      ),
                      );
                    },
                    ),
                  )
                  : Container(
                    child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Icon(
                        Icons.warning,
                        size: 50,
                        color: Colors.red,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'No contracts found',
                        style: TextStyle(fontSize: 20, color: Colors.red),
                      ),
                      ],
                    ),
                    ),
                  ),
        );
  }
}