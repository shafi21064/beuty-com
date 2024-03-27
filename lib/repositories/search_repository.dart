import 'package:kirei/app_config.dart';
import 'package:kirei/data_model/product_mini_response_home.dart';
import 'package:http/http.dart' as http;
import 'package:kirei/data_model/product_mini_response_old.dart';

import 'package:kirei/data_model/search_suggestion_response.dart';
import 'package:kirei/helpers/shared_value_helper.dart';

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
    //print(url);
    print(response.body.toString());
    return productMiniResponseFromJson(response.body);
  }
}
