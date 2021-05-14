import 'dart:convert';

import 'package:http/http.dart' as http;

mixin ItemDetail {
  ItemDetailResult itemDetail = new ItemDetailResult();
  Future<ItemDetailResult> getDetail(String id) async {
    final itemImageResponse = await fetchImage(id);
    if (itemImageResponse.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // Map<String, dynamic> descriptionResultJson =
      //     json.decode(itemDetailResponse.body);
      // itemDetail.name = descriptionResultJson['name'];
      // itemDetail.description = descriptionResultJson['description'];
      // final itemImageResponse = await fetchImage(id);
      // if (itemImageResponse.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> imageResultJson =
          json.decode(itemImageResponse.body);
      itemDetail.imageURL =
          imageResultJson['taxon']['dataObjects'][0]['eolMediaURL'];
      // }
      return itemDetail;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      itemDetail.name = 'test';
      itemDetail.description = 'test';
      itemDetail.imageURL = 'test';
      return itemDetail;
    }
  }

  Future<http.Response> fetchDescription(String id) {
    final Map<String, String> _queryParameters = <String, String>{
      'per_page': '0',
    };
    return http.get(Uri.https(
        'eol.org', 'api/collections/1.0/' + id + '.json', _queryParameters));
  }

  Future<http.Response> fetchImage(String id) {
    final Map<String, String> _queryParameters = <String, String>{
      'taxonomy': 'false',
    };
    return http.get(Uri.https(
        'eol.org', 'api/data_objects/1.0/' + id + '.json', _queryParameters));
  }
}

class ItemDetailResult {
  String name;
  String description;
  String imageURL;
  ItemDetailResult({this.name, this.description, this.imageURL});
}
