import 'package:encyclopedia_for_life/BackendService/backend_service.dart';
import 'package:encyclopedia_for_life/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AutocompleteSearchBar extends StatelessWidget {
  const AutocompleteSearchBar({this.onFocusChange});
  final Function onFocusChange;
  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Focus(
        onFocusChange: (focus) => onFocusChange(focus),
        child: TypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
            decoration: new InputDecoration(
              labelText: "Search",
              fillColor: Theme.of(context).buttonColor,
              // border: InputBorder.none,
              prefixIcon: Icon(Icons.search),
              border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(50.0),
                borderSide: new BorderSide(),
              ),
              //fillColor: Colors.green
            ),
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 20,
              color: Theme.of(context).textTheme.button.color,
            ),
          ),
          suggestionsCallback: (pattern) async {
            return await BackendService.getInstance().getSuggestions(pattern);
          },
          itemBuilder: (context, suggestion) {
            if ((suggestion.name as String).isEmpty) {
              return Container();
            }
            return Container(
              decoration: BoxDecoration(
                color: Color(0xFF2978b5),
                shape: BoxShape.rectangle,
                border: Border.all(
                    color: Theme.of(context)
                        .buttonColor //Theme.of(context).accentColor,
                    ),
              ),
              child: ListTile(
                  tileColor: Color(0xFF2978b5),
                  leading: Icon(Icons.pets),
                  title: Text(suggestion.name)),
            );
          },
          onSuggestionSelected: (suggestion) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DetailPage(
                      key: UniqueKey(),
                      pageId: suggestion.id,
                      showAppBar: true,
                    )));
          },
        ),
      ),
    );
  }
}
