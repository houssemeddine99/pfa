import 'package:digital_sales_app/Models/Product.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';

Widget SearchFProduct(BuildContext context, String hint, TextEditingController controller, List<Product> suggestions, {bool isRequired = true, Icon? prefixIcon, Function(Product)? onSuggestionTap}) {
  return SearchField<Product>(
    controller: controller,
    suggestions: suggestions
        .map(
          (product) => SearchFieldListItem<Product>(
            product.name,
            item: product,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList(),
    hint: hint,
    searchInputDecoration: SearchInputDecoration(
      errorStyle: TextStyle(fontSize: 0),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      prefixIcon: prefixIcon,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    itemHeight: 50,
    validator: (value) {
      if (isRequired && (value == null || value.isEmpty)) {
        return 'This field is required';
      }
      return null;
    },
    maxSuggestionsInViewPort: 3,
    suggestionItemDecoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    onSuggestionTap: (SearchFieldListItem<Product> suggestion) {
      if (onSuggestionTap != null) {
        if (suggestion.item != null) {
          onSuggestionTap(suggestion.item!);
        }
      print('Selected product: ${controller.text}');
    }},
  );
}