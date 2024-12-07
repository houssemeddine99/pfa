import 'package:digital_sales_app/Models/Client.dart';
import 'package:digital_sales_app/Models/Facture.dart';
import 'package:digital_sales_app/Models/FactureItem.dart';
import 'package:digital_sales_app/Models/Product.dart';
import 'package:digital_sales_app/Pages/AddFacture/widgets/SearchFieldProduct.dart';
import 'package:digital_sales_app/Services/ProductServices.dart';
import 'package:digital_sales_app/Services/SecureStorage.dart';
import 'package:digital_sales_app/Services/UserServices.dart';
import 'package:digital_sales_app/Pages/AddFacture/widgets/SearchField.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
class AddFacturePage extends StatefulWidget {
  final bool buy;

  const AddFacturePage({Key? key, required this.buy}) : super(key: key);

  @override
  AddFacturePageState createState() => AddFacturePageState();
}

class AddFacturePageState extends State<AddFacturePage> {
  Client? selectedClient;
  String? selectedFactureType;
  List<Map<String, dynamic>> products = [{'product': null, 'quantity': 1}];
  List<Product> productList = [];
  List<Client> clients = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchClients();
    fetchProducts();
  }

  void addProduct() {
    setState(() {
      products.add({'product': null, 'quantity': 1});
    });
  }

  void removeProduct(int index) {
    setState(() {
      products.removeAt(index);
    });
  }

  Future<void> fetchProducts() async {
    String? userId = await readUserID();
    String? token = await readToken();
    final fetchedProducts = await getProductsByUserId(userId!, token!);
    setState(() {
      if (fetchedProducts != null) {
        productList = fetchedProducts;
      }
      isLoading = false;
    });
  }

  Future<void> fetchClients() async {
    String? email = await readUserEmail();
    final fetchedClients = await getUserClientsByEmail(email!);
    setState(() {
      if (fetchedClients != null) {
        clients = fetchedClients;
      }
      isLoading = false;
    });
  }

  void postFacture() async {
    if (selectedClient != null && products.isNotEmpty) {
      String? token = await readToken();
              final uuid = Uuid();
            String?  userID = await readUserID();
      Facture newFacture = Facture(
        id: uuid.v4(),
        userID:  userID!, 
        clientID: selectedClient!.id,
        date: DateTime.now(),
        factureItems: products.map((item) {
          return FactureItem(
            product: item['product'],
            quantity: item['quantity'],
          );
        }).toList(),
        totalAmount: products.fold(0, (sum, item) => sum + (item['product'].price * item['quantity'])),
      );
      await createFacture(newFacture, token!);
    } else {
      // Use a logging framework instead of print
      debugPrint(selectedClient!.firstName);
      debugPrint('Please select a client and add at least one product.');
    }
    // Use a logging framework instead of print
    debugPrint('Facture posted');
  }

  Future<void> createFacture(Facture facture, String token) async {

  }

 @override
Widget build(BuildContext context) {
  // Controllers for the client and product fields
  final TextEditingController clientController = TextEditingController(
    text: selectedClient?.firstName ?? '',
  );

  return Scaffold(
    appBar: AppBar(
      title: Text(widget.buy ? 'Add Purchase' : 'Add Sale'),
    ),
    body: isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Client selection
                SearchF(
                  context,
                  'Select Client',
                  clientController,
                  clients,
                  prefixIcon: const Icon(Icons.person),
                  onSuggestionTap: (client) {
                    setState(() {
                      selectedClient = client;
                      clientController.text = client.name; // Update field text
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Product list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80.0), // Padding for spacing
                    itemCount: products.length + 1, // Add button counts as an extra item
                    itemBuilder: (context, index) {
                      if (index == products.length) {
                        // Add product button
                        return Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.add_circle, color: Colors.green, size: 36.0),
                            onPressed: addProduct,
                          ),
                        );
                      }

                      // Controller for the product field
                      final productController = TextEditingController(
                        text: products[index]['product']?.name ?? '',
                      );

                      // Product entry row
                      return Column(
                        children: [
                          Row(
                            children: [
                              // Product search field
                              Expanded(
                                flex: 3,
                                child: SearchFProduct(
                                  context,
                                  'Select Product',
                                  productController,
                                  productList,
                                  prefixIcon: const Icon(Icons.shopping_bag_outlined),
                                  onSuggestionTap: (product) {
                                    setState(() {
                                      products[index]['product'] = product;
                                      productController.text = product.name; // Update field text
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),

                              // Quantity input field
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Quantity',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 10.0,
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  initialValue: products[index]['quantity'].toString(),
                                  onChanged: (value) {
                                    setState(() {
                                      products[index]['quantity'] = int.parse(value);
                                    });
                                  },
                                ),
                              ),

                              // Remove product button
                              if (products.length > 1)
                                IconButton(
                                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                                  onPressed: () => removeProduct(index),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: () {
        print(products); // Debugging or testing output
      },
      backgroundColor: Colors.white,
      icon: Icon(Icons.add, color: Theme.of(context).primaryColor),
      label: Text(
        "Add Invoice",
        style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
      ),
    ),
  );
}
}