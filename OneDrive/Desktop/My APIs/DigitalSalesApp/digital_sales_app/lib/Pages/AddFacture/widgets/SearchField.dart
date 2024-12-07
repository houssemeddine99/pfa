import 'package:digital_sales_app/Models/Client.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';


Widget SearchF(BuildContext context, String hint, TextEditingController controller, List<Client> suggestions, {bool isRequired = true, Icon? prefixIcon, required Null Function(dynamic client) onSuggestionTap}) {
  return SearchField<Client>(
    controller: controller,
    suggestions: suggestions
        .map(
          (client) => SearchFieldListItem<Client>(
            client.firstName,
            item: client,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8 , 8, 16, 8),
              child: 
             
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Expanded(
                            child: Text(
                            client.firstName + " " + client.lastName,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            client.tel[0] + client.tel[1] + " " + client.tel.substring(2, 5) + " " + client.tel.substring(5, 8),
                            style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
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
    maxSuggestionsInViewPort:  3,
    suggestionItemDecoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    onSuggestionTap: (SearchFieldListItem<Client> suggestion) {
      
      if (onSuggestionTap != null) {
        if (suggestion.item != null) {
          print(controller.text);
          onSuggestionTap(suggestion.item!);
        }
      }
    },
  );
}