import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/helpers/endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:active_ecommerce_flutter/data_model/brand_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

class BrandRepository {
  Future<BrandResponse> getFilterPageBrands() async {
    Uri url = Uri.parse("${ENDP.FILTER_PAGE_BRANDS}");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    print("response,,,," + response.body);
    return brandResponseFromJson(response.body);
  }

  Future<BrandResponse> getBrands({name = "", page = 1}) async {
    Uri url = Uri.parse("${ENDP.GET_BRANDS}" + "?page=${page}&name=${name}");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    print(response.body);
    return brandResponseFromJson(response.body);
  }
}
