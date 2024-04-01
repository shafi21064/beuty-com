import 'package:kirei/data_model/business_setting_response.dart';
import 'package:kirei/helpers/endpoints.dart';
import 'package:http/http.dart' as http;


class BusinessSettingRepository{
  Future<List<BusinessSettingListResponse>> getBusinessSettingList()async{
    Uri url = Uri.parse("${ENDP.BUSINESS_SETTING}");

   var businessSettings = [
      "facebook_login",
      "google_login",
      "twitter_login",
      "pickup_point",
     "wallet_system"
    ];
  String params= businessSettings.join(',');
    var body = {
      "keys":params
    };
    print("business ${body}");
    var response = await http.post(url,body: body);

    print("business ${response.body}");

    return businessSettingListResponseFromJson(response.body);
  }
}