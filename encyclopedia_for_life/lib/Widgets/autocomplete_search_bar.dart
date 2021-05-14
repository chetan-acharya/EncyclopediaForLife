import 'package:encyclopedia_for_life/BackendService/backend_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AutocompleteSearchBar extends StatelessWidget {
  const AutocompleteSearchBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TypeAheadField(
      textFieldConfiguration: TextFieldConfiguration(
          autofocus: true,
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: 25,
            color: Colors.green,
          ),
          decoration: InputDecoration(border: OutlineInputBorder())),
      suggestionsCallback: (pattern) async {
        return await BackendService.getInstance().getSuggestions(pattern);
      },
      itemBuilder: (context, suggestion) {
        if ((suggestion.name as String).isEmpty) {
          return Container();
        }
        return ListTile(
            leading: Icon(Icons.pets), title: Text(suggestion.name));
      },
      onSuggestionSelected: (suggestion) {
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => ProductPage(product: suggestion)));
      },
    );
  }
}
