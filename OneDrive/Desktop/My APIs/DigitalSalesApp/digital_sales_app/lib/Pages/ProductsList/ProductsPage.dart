import 'package:digital_sales_app/Models/category.dart';
import 'package:digital_sales_app/Pages/Home/HomePage.dart';
import 'package:digital_sales_app/Pages/SourcePage.dart';
import 'package:digital_sales_app/Services/ProductServices.dart';
import 'package:digital_sales_app/Services/SecureStorage.dart';
import 'package:digital_sales_app/Widgets/AddClientWidget.dart';
import 'package:digital_sales_app/Pages/AddProduct/AddProductPage.dart';
import 'package:digital_sales_app/Pages/ProductsList/widgets/ProductCard.dart';
import 'package:digital_sales_app/Widgets/DialogAlert.dart';
import 'package:flutter/material.dart';
import 'package:digital_sales_app/Models/Product.dart';

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Product> products = [];
  List<Product> filteredProducts = [];
  List<Product> selectedProducts = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  void _addProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddProductWidget()),
    );
  }

  Future<void> fetchProducts() async {
    try {
      String userId = (await readUserID())!;
      String token = (await readToken())!;
      List<Product> fetchedProducts = await getProductsByUserId(userId, token);
      setState(() {
        products = fetchedProducts;
        filteredProducts = products;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
        print(errorMessage);
        isLoading = false;
      });
    }
  }

  void _deleteSelectedProducts() async {
    try {
      String token = (await readToken())!;
      List<String> productIds = selectedProducts.map((product) => product.id).toList();
      print(productIds);
      bool x=  await deleteProducts(productIds, token);
      if (x){
        await showAlert(
        context,
        title: "Succès",
        message: "Produits supprimés avec succès",
        type: AlertType.success,
        function: () {
      Navigator.of(context).pop();
        },
      );
      setState(() {
      products.removeWhere((product) => selectedProducts.contains(product));
      filteredProducts = products;
      selectedProducts.clear();
   
    });}
    } catch (error) {
      setState(() {
        errorMessage = error.toString();
        print(errorMessage);
      });
    }

  }

  void _clearSelection() {
    setState(() {
      selectedProducts.clear();
    });
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
              MaterialPageRoute(builder: (context) => BasePage(child: HomePage())),
            );
          },
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('Liste de Produits', style: TextStyle(color: Colors.white)),
        actions: selectedProducts.isNotEmpty
            ? [
                IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),  
                  onPressed: _deleteSelectedProducts,
                ),
              ]
            : null,
      ),
      body: GestureDetector(
        onTap: _clearSelection,
        child: Column(
          children: [
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : errorMessage.isNotEmpty
                      ? Center(child: Text('Error: $errorMessage'))
                      : products.isEmpty
                          ? Center(child: Text('No products found.'))
                          : ListView.builder(
                              itemCount: filteredProducts.length,
                              itemBuilder: (context, index) {
                                final product = filteredProducts[index];
                                final isSelected = selectedProducts.contains(product);
                                return GestureDetector(
                                  onTap: () {},
                                  onLongPress: () {
                                    setState(() {
                                      if (isSelected) {
                                        selectedProducts.remove(product);
                                      } else {
                                        selectedProducts.add(product);
                                      }
                                    });
                                  },
                                  child: Container(
                                    color: isSelected ? Colors.grey[300] : Colors.transparent,
                                    child: productCard(product: product),
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: !isLoading && products.isEmpty
          ? FloatingActionButton(
              onPressed: _addProduct,
              child: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
              backgroundColor: Colors.white,
            )
          : null,
      bottomNavigationBar: products.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          filteredProducts = products.where((product) {
                            final producName = product.name.toLowerCase();
                            final searchLower = value.toLowerCase();
                            return producName.contains(searchLower);
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
                    onPressed: _addProduct,
                    child: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(width: 10),
                ],
              ),
            )
          : null,
    );
  }
}
