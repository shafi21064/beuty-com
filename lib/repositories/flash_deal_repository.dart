import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/helpers/endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:active_ecommerce_flutter/data_model/flash_deal_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

class FlashDealRepository {
  Future<FlashDealResponse> getFlashDeals() async {

    Uri url = Uri.parse("${ENDP.FLASH_DEAL}");
    final response =
        await http.get(url,headers: {
          "App-Language": app_language.$,
        });
    return flashDealResponseFromJson(response.body);
  }
}
