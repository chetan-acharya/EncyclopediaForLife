import 'package:encyclopedia_for_life/BackendService/backend_service.dart';
import 'package:encyclopedia_for_life/detail_page.dart';
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
        decoration: new InputDecoration(
          labelText: "Search",
          fillColor: Colors.white,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(50.0),
            borderSide: new BorderSide(),
          ),
          //fillColor: Colors.green
        ),
        autofocus: true,
        style: TextStyle(
          fontStyle: FontStyle.italic,
          fontSize: 20,
          color: Colors.green,
        ),
      ),
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
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => DetailPage(suggestion.id)));
      },
    );
  }
}
