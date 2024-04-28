import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:kirei/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:kirei/data_model/product_mini_response_old.dart';

import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:kirei/ui_elements/product_card.dart';

class SearchRepository {
  Future<ProductMiniResponse> getSearchSuggestionListResponse(
      {query_key = ""}) async {
        
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/gigalogy/items/search?search=$query_key&gaip_user_id=${null}");
    final response = await http.get(
      url,
      headers: {
        "App-Language": app_language.$,
      },
    );
    print(response.body.toString());
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getSearchByImageProductListResponse(
      {Uint8List imageBytes, String imageName}
      ) async {

    ///upload image for search product by multipart request
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/gigalogy/items/search");
      var request = http.MultipartRequest('POST', url);


    var image = http.MultipartFile.fromBytes('image', imageBytes, filename: imageName);
    request.files.add(image);

      request.fields['order_by'] = "default";

      var response = await http.Response.fromStream(await request.send());

      print('${response.body}');

      if (response.statusCode == 200) {
        print('Image uploaded successfully');
      } else {
        print('Failed to upload image. Error: ${response.reasonPhrase}');
      }
    return productMiniResponseFromJson(response.body);
    //return jsonDecode(response.body);
  }
}
