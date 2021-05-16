import 'dart:convert';

import 'package:http/http.dart' as http;

mixin ItemDetail {
  //variable in ItemDetail mixin, needs to be initialized in a method of ItemDetail
  ItemDetailResult itemDetail;
  Future<ItemDetailResult> getDetail(String id) async {
    itemDetail = new ItemDetailResult(imageURLs: []);
    final itemDetailResponse = await fetchDescription(id);

    if (itemDetailResponse.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> descriptionResultJson =
          json.decode(itemDetailResponse.body);

      itemDetail.description = descriptionResultJson['brief_summary'];

      //getting the image of item after getting text was successful
      final itemImageResponse = await fetchImage(id);

      if (itemImageResponse.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.

        try {
          Map<String, dynamic> imageResultJson =
              json.decode(itemImageResponse.body);

          //getting images and using it in imageURl

          for (var item in imageResultJson['taxonConcept']['dataObjects']) {
            itemDetail.imageURLs.add(item['eolMediaURL']);
          }
        } catch (e) {
          //getting image of 'no image available' to show when image data was not present in
          //previous API call

          itemDetail.imageURLs.add(
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqICensWiWUSbyUFkXY0e1HL3H0ITIN1uuXetIyeyGJ9N21WfH5Pps1TxF7YLMFYaaq6E&usqp=CAU');
        }
      }
      return itemDetail;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      itemDetail.name = '';
      itemDetail.description =
          'No random data available. Pull from the top to refresh.';
      itemDetail.imageURLs.add(
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqICensWiWUSbyUFkXY0e1HL3H0ITIN1uuXetIyeyGJ9N21WfH5Pps1TxF7YLMFYaaq6E&usqp=CAU');
      return itemDetail;
    }
  }

  Future<http.Response> fetchDescription(String id) {
    return http
        .get(Uri.https('eol.org', 'api/pages/' + id + '/brief_summary.json'));
  }

  Future<http.Response> fetchImage(String id) {
    final Map<String, String> _queryParameters = <String, String>{
      'taxonomy': 'false',
      'images_per_page': '10',
      'details': 'false'
    };
    return http.get(Uri.https(
        'eol.org', 'api/pages/1.0/' + id + '.json', _queryParameters));
  }
}

//model class for item detail result
class ItemDetailResult {
  String name;
  String description;
  List<String> imageURLs;
  ItemDetailResult({this.name, this.description, this.imageURLs});
}
