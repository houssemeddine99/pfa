import 'package:digital_sales_app/Models/Product.dart';
import 'package:digital_sales_app/Pages/ProductsList/ProductDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../../../Widgets/DialogAlert.dart';

class productCard extends StatelessWidget {
  final Product product;
  const productCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
    showDialog(
    context: context,
    builder: (BuildContext context) {
      return ProductDetailsDialog(product: product);
    },
  );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 5, right: 5),
        child: Container(
          margin: const EdgeInsets.only(left: 10, top: 10 , right: 20),
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 4,
                offset: Offset(0, 3),
              ),
            ],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                imageSection(),
                SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LineRow(),
                      DepToDest_Row(),
                      TypeRow(),
                      PriceRow(),
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                        Icons.edit,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row PriceRow() {
    return Row(
      children: [
        Text(
          "Price: ",
          style: TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold),
        ),
        Text(
          product.price.toStringAsFixed(3) + " DT",
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Row TypeRow() {
    return Row(
      children: [
        Text(
          product.category.name,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
          
            fontSize: 12,
          ),
        ),
        SizedBox(
          width:3,
        ),
        
                Icon(
                  Icons.camera_alt_outlined,
                  color: Color(0xFF042F40),
                  size: 17,
                ),

      ],
    );
  }

  Row DepToDest_Row() {
    return Row(
      children: [
        Text(
          product.quantity.toString() + " in stock",
          style:
              TextStyle(fontFamily: 'Roboto', fontSize: 13,   color: product.quantity > 20 ? Color(0xFF5DC15D) : Colors.red,),
        ),
        Icon(
          Icons.clear_all ,
           color: product.quantity > 20 ? Color(0xFF5DC15D) : Colors.red,
        ),
      ],
    );
  }

  Text LineRow() {
    return Text(
      product.name.toString(),
      style:  TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: Color.fromARGB(255, 49, 60, 64),
      ),
    );
  }

  Container imageSection() {
    return Container(
      width: 90,
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.04),
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
                image: NetworkImage(product.image), fit: BoxFit.cover)),
    );
  }
}