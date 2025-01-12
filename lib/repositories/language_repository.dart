import 'package:kirei/helpers/endpoints.dart';
import 'package:http/http.dart' as http;

import 'package:kirei/data_model/language_list_response.dart';
import 'package:kirei/helpers/shared_value_helper.dart';

class LanguageRepository {
  Future<LanguageListResponse> getLanguageList() async {
    Uri url = Uri.parse(
        "${ENDP.LANGUAGES}");
    final response = await http.get(url,headers: {
      "App-Language": app_language.$,
    }
    );
    return languageListResponseFromJson(response.body);
  }


}
