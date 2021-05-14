import 'autocomplete_search.dart';

class BackendService with AutocompleteSearch {
  static BackendService _instance;
  static BackendService getInstance() {
    if (_instance == null) {
      _instance = BackendService();
    }
    return _instance;
  }
}
