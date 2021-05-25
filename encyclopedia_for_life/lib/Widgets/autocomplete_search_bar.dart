import 'package:encyclopedia_for_life/BackendService/backend_service.dart';
import 'package:encyclopedia_for_life/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';

class AutocompleteSearchBar extends StatelessWidget {
  const AutocompleteSearchBar({this.onFocusChange});
  final Function onFocusChange;
  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Focus(
        onFocusChange: (focus) => onFocusChange(focus),
        child: TypeAheadField(
          textFieldConfiguration: getSearchBarWidget(context),
          suggestionsCallback: (pattern) async {
            return await BackendService.getInstance().getSuggestions(pattern);
          },
          itemBuilder: (context, suggestion) {
            if ((suggestion.name as String).isEmpty) {
              return Container();
            }
            return getSearchListWidget(context, suggestion);
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

  Container getSearchListWidget(BuildContext context, suggestion) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(50)),
        color: Color(0xFF2978b5),
        border: Border.all(
            color:
                Theme.of(context).buttonColor //Theme.of(context).accentColor,
            ),
      ),
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Flexible(
                child: Icon(Icons.pets),
                flex: 2,
              ),
            ),
            Flexible(
              child: Text(suggestion.name),
              flex: 6,
            )
          ],
        ),
      ),
    );
  }

  TextFieldConfiguration getSearchBarWidget(BuildContext context) {
    return TextFieldConfiguration(
      decoration: new InputDecoration(
        labelText: "Search",
        labelStyle: GoogleFonts.anton(fontStyle: FontStyle.normal),
        enabledBorder: OutlineInputBorder(
          // width: 0.0 produces a thin "hairline" border
          borderRadius: new BorderRadius.circular(50.0),
          borderSide: new BorderSide(color: Colors.lightBlue, width: 2),
        ),
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
    );
  }
}
