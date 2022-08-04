import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/extra_community_HashTags_response.dart';
import 'package:active_ecommerce_flutter/data_model/extra_community_response.dart';
import 'package:http/http.dart' as http;
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

class ExtraRepository {

  Future<CommunityPostResponse> getCommunityPosts() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL_1}/community-posts");
    final response =
    await http.get(url,headers: {
      "App-Language": app_language.$,
    });
    print(url);
    print(response.body.toString());

    return communityPostResponseFromJson(response.body);
  }

  Future<CommunityHashtags> getCommunityHashTags() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL_1}/community-hashtags");
    final response =
    await http.get(url,headers: {
      "App-Language": app_language.$,
    });
    print(url);
    print(response.body.toString());

    return communityHashtagsFromJson(response.body);
  }




}
