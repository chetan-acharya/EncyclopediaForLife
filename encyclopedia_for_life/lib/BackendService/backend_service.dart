import 'autocomplete_search.dart';
import 'item_detail.dart';

// this is a common class for all the API methods
class BackendService with AutocompleteSearch, ItemDetail {
  static BackendService _instance;

  //method to access all the methods from the mixin and local methods
  static BackendService getInstance() {
    if (_instance == null) {
      _instance = BackendService();
    }
    return _instance;
  }
}
