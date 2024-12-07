
import 'package:digital_sales_app/Services/ProductServices.dart';
import 'package:digital_sales_app/Services/SecureStorage.dart';
import 'package:digital_sales_app/Services/UserServices.dart';
import 'package:digital_sales_app/Pages/AddProduct/AddProductPage.dart';
import 'package:digital_sales_app/Widgets/DialogAlert.dart';
import 'package:flutter/material.dart';

class AddCategoryWidget extends StatefulWidget {
  @override
  _AddCategoryWidgetState createState() => _AddCategoryWidgetState();
}

class _AddCategoryWidgetState extends State<AddCategoryWidget> {
  final _formKey = GlobalKey<FormState>();
  final _categoryNameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _categoryNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final categoryName = _categoryNameController.text.isNotEmpty
          ? _categoryNameController.text[0].toUpperCase() +
              _categoryNameController.text.substring(1).toLowerCase()
          : '';
      final description = _descriptionController.text;
      String ch;
      String? userID = await readUserID();
      String? token = await readToken();
      ch = await addCategory(userID!, categoryName, token!);
      if (ch == "ok") {
        await showAlert(
          context,
          title: "Succès",
          message: "Catégorie créée avec succès.",
          type: AlertType.success,
          function: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AddProductWidget()),
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
      title: Text('Ajouter une catégorie'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: _categoryNameController,
              decoration: InputDecoration(labelText: 'Nom de la catégorie'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un nom de catégorie';
                }
                if (value.length < 3) {
                  return 'Le nom de la catégorie doit comporter au moins 2 caractères';
                }
                return null;
              },
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
