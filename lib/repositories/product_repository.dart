import 'package:flutter/cupertino.dart';
import 'package:kirei/app_config.dart';
import 'package:kirei/data_model/product_mini_response_old.dart';
import 'package:http/http.dart' as http;
import 'package:kirei/data_model/product_mini_response_home.dart';
import 'package:kirei/data_model/product_details_response_new.dart';
import 'package:kirei/data_model/variant_response.dart';
import 'package:flutter/foundation.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:kirei/providers/version_change.dart';
import 'package:provider/provider.dart';

class ProductRepository {
  Future<ProductMiniResponseHome> getHomeProducts(BuildContext context) async {
    //Uri url = Uri.parse("${AppConfig.BASE_URL}/home-products?version=2.0.8");
    Uri url = Uri.parse("${AppConfig.BASE_URL}/home-products?version=${Provider.of<VersionChange>(context, listen: false).latestVersion}");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    print(response.body);

    return productMiniResponseHomeFromJson(response.body);
    //  String jsonData = await rootBundle.loadString('assets/home_products.json');
    //
    // // Parse the JSON data
    // ProductMiniResponseHome productResponse = productMiniResponseHomeFromJson(jsonData);
    // return productResponse;
  }

  Future<ProductMiniResponse> getRecommendedProducts() async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/gigalogy/users/search/recommend?gaip_user_id=${null}");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    print(response.body);
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getPopularSearchProducts() async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/gigalogy/users/recommend?gaip_user_id=${null}");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    print(response.body);
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getTrendingProducts() async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/gigalogy/items/trending?gaip_user_id=${null}");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    print(response.body);
    return productMiniResponseFromJson(response.body);
  }


  Future<ProductMiniResponse> getTodaysDealProducts() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/products/todays-deal");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getFlashDealProducts(
      {@required int id = 0}) async {
    Uri url =
        Uri.parse("${AppConfig.BASE_URL}/flash-deal-products/" + id.toString());
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getCategoryProducts(
      {@required name = "", page = 1}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/gigalogy/items/search?" +
        "category=${name}&page=${page}&gaip_user_id=${null}");
    print(url);
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getShopProducts(
      {@required int id = 0, name = "", page = 1}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/products/seller/" +
        id.toString() +
        "?page=${page}&name=${name}");

    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getBrandProducts(
      {@required int id = 0, name = "", page = 1}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/products/brand/" +
        id.toString() +
        "?page=${page}&name=${name}");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getFilteredProducts({
    String name = "",
    int page = 1,
    String sort_key = "",
    String categories = "",
    String skin_type = "",
    String tag = "",
    String min = "",
    String max = "",
    String type = "",
    String search = "",
    String key_ingredients = "",
    String good_for = "",
  }) async {
    Map<dynamic, dynamic> parameters = {
      'page': page,
      'order_by': sort_key,
    };

    if (name != "") parameters['search'] = name;
    if (categories != null && categories != "")
      parameters['category'] = categories.toLowerCase().replaceAll(' ', '-');
    if (skin_type != null && skin_type != "")
      parameters['skin_type'] = skin_type.toLowerCase().replaceAll(' ', '-');
    if (min != null && min != "") parameters['min_price'] = int.tryParse(min);
    if (max != null && max != "") parameters['max_price'] = int.tryParse(max);
    if (key_ingredients != null && key_ingredients != "")
      parameters['key_ingredients'] =
          key_ingredients.toLowerCase().replaceAll(' ', '-');
    if (good_for != null && good_for != "")
      parameters['good_for'] = good_for.toLowerCase().replaceAll(' ', '-');
    if (tag != null && tag != "")
      parameters['tag'] = tag.toLowerCase().replaceAll(' ', '-');
    if (type != null && type != "")
      parameters['type'] = type.toLowerCase().replaceAll(' ', '-');
    if (search != null && search != "")
      parameters['search'] = type.toLowerCase().replaceAll(' ', '-');
    // Constructing the query string manually
    String queryString = parameters.entries
        .map((entry) =>
            '${entry.key}=${Uri.encodeComponent(entry.value.toString())}')
        .join('&');

    // Append gaip_user_id=null at the end
    queryString += '&gaip_user_id=null';

    // Construct the final URL
    Uri url =
        Uri.parse("${AppConfig.BASE_URL}/gigalogy/items/search?$queryString");
    print(url);

    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });

    return productMiniResponseFromJson(response.body.toString());
  }

  Future<ProductDetailsResponse> getProductDetails(
      {@required String id}) async {
    Uri url =
        Uri.parse("${AppConfig.BASE_URL}/products/details/" + id.toString());
    print(url.toString());
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
     print("kireiBBLatest: "+response.body.toString());
    return productDetailsResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getRelatedProducts(
      {@required String slug}) async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/gigalogy/related-products/" +
        slug +
        "?gaip_user_id=${null}");
    print(url);
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    print(response.body);
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponse> getPurchasedTogether(
      {@required String slug}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/gigalogy/items/purchased/together/" +
            slug +
            "?gaip_user_id=${null}");
    print(url);
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    print(response.body);
    return productMiniResponseFromJson(response.body);
  }

  Future<ProductMiniResponseHome> getTopFromThisSellerProducts(
      {@required int id = 0}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/products/top-from-seller/" + id.toString());
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    return productMiniResponseHomeFromJson(response.body);
  }

  Future<VariantResponse> getVariantWiseInfo(
      {int id = 0, color = '', variants = ''}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/products/variant/price?id=${id.toString()}&color=${color}&variants=${variants}");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });

    return variantResponseFromJson(response.body);
  }
}
