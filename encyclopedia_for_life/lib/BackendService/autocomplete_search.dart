import 'dart:convert';

import 'package:http/http.dart' as http;

mixin AutocompleteSearch {
  getSuggestions(String searchParam) async {
    final response = await fetchItems(searchParam);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Iterable searchResultJson = json.decode(response.body);
      List<SearchResult> searchResults = List<SearchResult>.from(
          searchResultJson.map((model) => SearchResult.fromJson(model)));
      return searchResults;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      List<SearchResult> searchResults = [];
      searchResults.add(SearchResult(name: ''));
      return searchResults;
    }
  }

  Future<http.Response> fetchItems(String searchParam) {
    return http.get(Uri.https('eol.org', 'autocomplete/' + searchParam));
  }
}

class SearchResult {
  final String name;
  final String id;

  SearchResult({this.name, this.id});

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(name: json['name'], id: json['id']);
  }
}
