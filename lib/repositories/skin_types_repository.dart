import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/skin_type_response.dart';
import 'package:active_ecommerce_flutter/helpers/endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:active_ecommerce_flutter/data_model/brand_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

class SkinTypesRepository {
  Future<SkinTypesResponse> getFilterPageSkinTypes() async {
    Uri url = Uri.parse("${ENDP.FILTER_PAGE_SKINTYPES}");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    print("response,,,," + response.body);
    return skinTypesResponseFromJson(response.body);
  }
}
