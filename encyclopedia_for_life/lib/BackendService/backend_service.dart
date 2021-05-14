import 'autocomplete_search.dart';
import 'item_detail.dart';

class BackendService with AutocompleteSearch, ItemDetail {
  static BackendService _instance;
  static BackendService getInstance() {
    if (_instance == null) {
      _instance = BackendService();
    }
    return _instance;
  }
}
