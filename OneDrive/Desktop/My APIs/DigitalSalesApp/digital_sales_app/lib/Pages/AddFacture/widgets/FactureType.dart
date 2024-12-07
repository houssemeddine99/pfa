import 'package:digital_sales_app/Pages/AddFacture/AddFacturePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:searchfield/searchfield.dart';

class FactureTypeDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Choisissez le type de facture',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Achat de produits'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddFacturePage(buy: true),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.sell),
            title: Text('Vente de produits'),
            onTap: () {
              // Add your onTap functionality here
            },
          ),
        ],
      ),
    );
  }
}

void showFactureTypeDialog(BuildContext context) async {
  final result = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return FactureTypeDialog();
    },
  );
}


