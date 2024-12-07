import 'package:digital_sales_app/Models/Category.dart';
import 'package:digital_sales_app/Models/Product.dart';
import 'package:digital_sales_app/Pages/ProductsList/ProductsPage.dart';
import 'package:digital_sales_app/Services/ProductServices.dart';
import 'package:digital_sales_app/Services/SecureStorage.dart';
import 'package:digital_sales_app/Widgets/DialogAlert.dart';
import 'package:flutter/material.dart';

class ProductDetailsDialog extends StatefulWidget {
  final Product product;

  ProductDetailsDialog({required this.product});

  @override
  _ProductDetailsDialogState createState() => _ProductDetailsDialogState();
}

class _ProductDetailsDialogState extends State<ProductDetailsDialog> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;
  String? _selectedCategory;
  bool isChanged = false;
  List<Category> _categories = [];

  Future<void> _fetchCategories() async {
    String? userId = await readUserID();
    String? token = await readToken();
    if (userId != null && token != null) {
      List<Category> categories = await getCategorysByUserId(userId, token);
      setState(() {
        _categories = categories;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _priceController =
        TextEditingController(text: widget.product.price.toString());
    _quantityController =
        TextEditingController(text: widget.product.quantity.toString());
    _selectedCategory = widget.product.category.name;

    _nameController.addListener(_onChanged);
    _priceController.addListener(_onChanged);
    _quantityController.addListener(_onChanged);

    _fetchCategories();
  }

  void _onChanged() {
    setState(() {
      isChanged = true;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Implement photo change functionality here
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(widget.product.image),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(
                          8), // Changed to 8 for squared corners
                      border: Border.all(color: Colors.grey, width: 2),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              _buildEditableField('Name', _nameController),
              SizedBox(height: 16),
              _buildEditableField('Price', _priceController),
              SizedBox(height: 16),
              _buildEditableField('Quantity', _quantityController),
              SizedBox(height: 16),
              _buildCategoryDropdown(),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: isChanged
                        ? () async {
                            String? userId = await readUserID();
                            String? token = await readToken();
                            if (userId != null && token != null) {
                              Product updatedProduct = Product(
                                id: widget.product.id,
                                name: _nameController.text,
                                price: double.parse(_priceController.text),
                                quantity: int.parse(_quantityController.text),
                                category: _categories.firstWhere((category) =>
                                    category.name == _selectedCategory),
                                image: widget.product.image,
                                idUser: userId,
                              );
                              bool success =
                                  await updateProduct(updatedProduct, token);
                              if (success) {
                                await showAlert(
                                  context,
                                  title: "Succès",
                                  message: "Produit modifié avec succès.",
                                  type: AlertType.success,
                                  function: () {
                                    Navigator.of(context)
                                        .popUntil((route) => route.isFirst);
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => ProductsPage(),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                await showAlert(
                                  context,
                                  title: "Erreur",
                                  message:
                                      "Erreur lors de la modification du produit.",
                                  type: AlertType.error,
                                  function: () {
                                    Navigator.of(context).pop();
                                  },
                                );
                              }
                            }
                          }
                        : null,
                    child: Text('Update'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text('Cancel'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      items: _categories.map((Category category) {
        return DropdownMenuItem<String>(
          value: category.name,
          child: Text(category.name),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedCategory = newValue;
          isChanged = true;
        });
      },
      decoration: InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
