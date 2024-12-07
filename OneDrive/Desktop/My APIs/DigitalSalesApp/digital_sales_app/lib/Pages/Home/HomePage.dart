import 'package:digital_sales_app/Pages/AddFacture/AddFacturePage.dart';
import 'package:digital_sales_app/Pages/AddFacture/widgets/FactureType.dart';
import 'package:digital_sales_app/Pages/AddProduct/AddProductPage.dart';
import 'package:digital_sales_app/Pages/ProductsList/ProductsPage.dart';
import 'package:digital_sales_app/Services/SecureStorage.dart';
import 'package:digital_sales_app/Widgets/AddClientWidget.dart';
import 'package:digital_sales_app/Pages/Home/widgets/HomePageButton.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.045),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.08,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Color(0xFFE7F1F9)
                  ],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Products',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.add_circle_rounded,
                              color: Colors.white),
                          onPressed: () {
                               Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddProductWidget()),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.view_list_rounded,
                              color: Colors.white),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductsPage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
            child: Row(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "WELCOME TO DIGITAL SALES APP",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomButton(
                text: 'Nouvelle Facture',
                icon: const Icon(
                  Icons.handshake_rounded,
                  size: 40,
                ),
                onPressed: () {
               showFactureTypeDialog(context);
                },
              ),
              const SizedBox(width: 13),
              CustomButton(
                text: "Ajouter un Client",
                icon: const Icon(
                  Icons.person_add_alt_1,
                  size: 40,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AddClientWidget();
                    },
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomButton(
                text: 'Ajouter un produit',
                icon: const Icon(
                  Icons.library_add,
                  size: 40,
                ),
                onPressed: () {
                  // Add your onPressed code here!
                },
              ),
              const SizedBox(width: 20),
              CustomButton(
                text: "Nouvelle rapport",
                icon: const Icon(
                  Icons.report,
                  size: 40,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
