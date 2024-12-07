import 'package:digital_sales_app/.env.dart';
import 'package:digital_sales_app/Models/Category.dart';
import 'package:digital_sales_app/Models/Product.dart';
import 'package:digital_sales_app/Pages/ProductsList/ProductsPage.dart';
import 'package:digital_sales_app/Services/ProductServices.dart';
import 'package:digital_sales_app/Services/SecureStorage.dart';
import 'package:digital_sales_app/Widgets/AddCategoryWidget.dart';
import 'package:digital_sales_app/Widgets/DialogAlert.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddProductWidget extends StatefulWidget {
  const AddProductWidget({Key? key}) : super(key: key);

  @override
  AddProductWidgetState createState() => AddProductWidgetState();
}

class AddProductWidgetState extends State<AddProductWidget> {
  File? _image;
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  Category? _selectedCategory;
  List<Category> _categories = [];
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

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

  
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Photo Library'),
                onTap: () async {
                  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    File? croppedFile = await _cropImage(File(pickedFile.path));
                    if (croppedFile != null) {
                      setState(() {
                        _image = croppedFile;
                      });
                    }
                  }
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () async {
                  final pickedFile = await picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    File? croppedFile = await _cropImage(File(pickedFile.path));
                    if (croppedFile != null) {
                      setState(() {
                        _image = croppedFile;
                      });
                    }
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<File?> _cropImage(File imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
                 aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        ),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      ],
    );
    return croppedFile != null ? File(croppedFile.path) : null;
  }
  Future<String> _uploadImageToImgur() async {
    String rep = "";
    if (_image == null) return '';

    setState(() {
      _isUploading = true;
    });

    try {
      final uri = Uri.parse('https://api.imgur.com/3/image');
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = imgurClientId
        ..files.add(await http.MultipartFile.fromPath('image', _image!.path));

      final response = await request.send();
      
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);
        final imageUrl = jsonResponse['data']['link'];
        print('Image uploaded: $imageUrl');
        rep = imageUrl;
      } else {
        print('Error uploading image: ${response.statusCode}');
        return 'error';
      }
    } catch (e) {
      print('Error uploading image: $e');
      return 'error';
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
    return rep;
  }

  void _submit() async {
    if (_nameController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _quantityController.text.isEmpty ||
        _selectedCategory == null ||
        _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    String rep = await _uploadImageToImgur();
    String? userId = await readUserID();
    String? token = await readToken();
    if (rep == 'error') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image')),
      );
      return;
    }
    Product product = Product(
      id: '',
      name: _nameController.text,
      image: rep,
      price: double.parse(_priceController.text),
      quantity: int.parse(_quantityController.text),
      category: _selectedCategory!,
      idUser: userId!,
    );

    bool success = await addProduct(product, token!);
    if (success) {
      await showAlert(
        context,
        title: "Succès",
        message: "Produit créé avec succès.",
        type: AlertType.success,
        function: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
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
        message: "Erreur lors de l'ajout du produit.",
        type: AlertType.error,
        function: () {
          Navigator.of(context).pop();
        },
      );
    }
  }

  void _cancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    double fieldHeight;
    if (screenHeight * 0.07 < 44) {
      fieldHeight = 44;
    } else {
      fieldHeight = screenHeight * 0.07;
    }

    return Scaffold(
      appBar: AppBar(
        
           leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Colors.white,
        ),
                backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('Add Product',style: TextStyle(color: Colors.white)),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
               SizedBox(height: 20),
              ImageContainer(screenHeight),
              SizedBox(height: 20),
              SizedBox(
                height: fieldHeight,
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                
                  SizedBox(
                    height: fieldHeight,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: DropdownButtonFormField<Category>(
                      value: _selectedCategory,
                      hint: Text(_categories.isEmpty
                          ? 'There are no categories'
                          : 'Select Category'),
                      items: _categories.map((Category category) {
                        return DropdownMenuItem<Category>(
                          value: category,
                          child: Text(category.name),
                        );
                      }).toList(),
                      onChanged: _categories.isEmpty
                          ? null
                          : (Category? newValue) {
                              setState(() {
                                _selectedCategory = newValue;
                              });
                            },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
           
                  SizedBox(
                    height: fieldHeight,
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AddCategoryWidget();
                          },
                        );
                      },
                      child: Center(child: Icon(Icons.add)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                height: fieldHeight,
                child: TextField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: fieldHeight,
                child: TextField(
                  controller: _quantityController,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isUploading ? null : _submit,
                  child: _isUploading
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector ImageContainer(double screenHeight) {
    return GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: screenHeight * 0.3,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: _image == null
                    ? Center(child: Text('No image selected. Tap to select.'))
                    : Image.file(_image!, fit: BoxFit.cover),
              ),
            );
  }
}
