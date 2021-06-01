import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

mixin ItemDetail {
  //variable in ItemDetail mixin, needs to be initialized in a method of ItemDetail
  ItemDetailResult itemDetail;
  Future<ItemDetailResult> getDetail(String id, {bool isRandom = false}) async {
    itemDetail = new ItemDetailResult(imageDetailList: []);

    final itemImageResponse = await fetchImage(id);

    if (itemImageResponse.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      try {
        Map<String, dynamic> imageResultJson =
            json.decode(itemImageResponse.body);

        //getting images and using it in imageURl
        for (var item in imageResultJson['taxonConcept']['dataObjects']) {
          var imageDetail = ImageDetail();
          if (item['license'].toString().contains('by-')) {
            imageDetail.licenseInformation = item['rightsHolder'] +
                '  \ncc-' +
                item['license'].toString().split(
                    '/')[item['license'].toString().split('/').length - 3];
          } else {
            imageDetail.licenseInformation = 'Public Domain';
          }
          imageDetail.imageUrl = item['eolMediaURL'];
          itemDetail.imageDetailList.add(imageDetail);
        }
        //get description data and return the result
        return await getDescriptionData(id, isRandom);
      } catch (e) {
        if (isRandom) {
          return getDetail(Random().nextInt(50000).toString(),
              isRandom: isRandom);
        }
        //getting image of 'no image available' to show when image data was not present in
        //previous API call
        var imageDetail = ImageDetail();
        imageDetail.licenseInformation = '';
        imageDetail.imageUrl =
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqICensWiWUSbyUFkXY0e1HL3H0ITIN1uuXetIyeyGJ9N21WfH5Pps1TxF7YLMFYaaq6E&usqp=CAU';
        itemDetail.imageDetailList.add(imageDetail);
        //get description data and return the result
        return await getDescriptionData(id, isRandom);
      }
    } else {
      //try to get another random item with image and detail
      if (isRandom) {
        return getDetail(Random().nextInt(50000).toString(),
            isRandom: isRandom);
      }

      var imageDetail = ImageDetail();
      imageDetail.licenseInformation = '';
      imageDetail.imageUrl =
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqICensWiWUSbyUFkXY0e1HL3H0ITIN1uuXetIyeyGJ9N21WfH5Pps1TxF7YLMFYaaq6E&usqp=CAU';
      itemDetail.imageDetailList.add(imageDetail);
      //get description data and return the result
      return await getDescriptionData(id, isRandom);
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

  Future<ItemDetailResult> getDescriptionData(String id, bool isRandom) async {
    final itemDetailResponse = await fetchDescription(id);

    if (itemDetailResponse.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      try {
        Map<String, dynamic> descriptionResultJson =
            json.decode(itemDetailResponse.body);

        itemDetail.description = descriptionResultJson['brief_summary'];

        return itemDetail;
      } catch (e) {
        if (isRandom) {
          return getDetail(Random().nextInt(50000).toString(),
              isRandom: isRandom);
        }
        itemDetail.description =
            'Data not available. Explore other spicies while we update our data.';
        return itemDetail;
      }
    } else {
      if (isRandom) {
        return getDetail(Random().nextInt(50000).toString(),
            isRandom: isRandom);
      }
      itemDetail.description =
          'Data not available. Explore other spicies while we update our data.';
      return itemDetail;
    }
  }
}

//model class for item detail result
class ItemDetailResult {
  String name;
  String description;
  List<ImageDetail> imageDetailList;

  ItemDetailResult({this.name, this.description, this.imageDetailList});
}

class ImageDetail {
  String imageUrl;
  String licenseInformation;
  ImageDetail({this.imageUrl, this.licenseInformation});
}
