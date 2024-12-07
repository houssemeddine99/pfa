import 'package:digital_sales_app/Pages/ClientsList/MyClientsPage.dart';
import 'package:digital_sales_app/Services/SecureStorage.dart';
import 'package:digital_sales_app/Services/UserServices.dart';
import 'package:digital_sales_app/Widgets/DialogAlert.dart';
import 'package:flutter/material.dart';

class AddClientWidget extends StatefulWidget {
  @override
  _AddClientWidgetState createState() => _AddClientWidgetState();
}

class _AddClientWidgetState extends State<AddClientWidget> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final phone = _phoneController.text;
      final firstName = _firstNameController.text.isNotEmpty
          ? _firstNameController.text[0].toUpperCase() +
              _firstNameController.text.substring(1).toLowerCase()
          : '';
      final lastName = _lastNameController.text.isNotEmpty
          ? _lastNameController.text[0].toUpperCase() +
              _lastNameController.text.substring(1).toLowerCase()
          : '';
      String ch;
      String? userID = await readUserID();
      ch = await addClient(userID!, phone, firstName, lastName);
      if (ch == "ok") {
        await showAlert(
          context,
          title: "Succès",
          message: "Contrat créé avec succès.",
          type: AlertType.success,
          function: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => MyClientsPage(),
              ),
            );
          },
        );
      } else {
        await showAlert(
          context,
          title: "Erreur",
          message: ch,
          type: AlertType.error,
          function: () {
            Navigator.of(context).pop();
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ajouter un client'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Numéro de téléphone'),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un numéro de téléphone';
                }
                if (value.length != 8) {
                  return 'Veuillez entrer un numéro de téléphone valide';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'Prénom'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un prénom';
                }
                if (value.length < 3) {
                  return 'Le prénom doit comporter au moins 2 caractères';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Nom de famille (Optionnel)'),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: Text('Ajouter'),
        ),
      ],
    );
  }
}
