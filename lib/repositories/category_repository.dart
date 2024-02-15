import 'package:kirei/app_config.dart';
import 'package:kirei/data_model/feature_category_response.dart';
import 'package:kirei/helpers/endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:kirei/data_model/category_response.dart';
import 'package:kirei/helpers/shared_value_helper.dart';

class CategoryRepository {
  Future<CategoryResponse> getCategories({parent_id = 0}) async {
    Uri url = Uri.parse("${ENDP.GET_CATEGORIES}");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    print("${ENDP.GET_CATEGORIES}");
    print("All categoriesssss: ${response.body.toString()}");
    return categoryResponseFromJson(response.body);
  }

  Future<List<FeaturedCategory>> getHomeFeaturedCategories() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/home-featured-categories");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    print("${ENDP.GET_CATEGORIES}");
    print("categoriesssss: ${response.body.toString()}");
    return featuredCategoryListFromJson(response.body);
  }

  Future<CategoryResponse> getFeturedCategories() async {
    Uri url = Uri.parse("${ENDP.GET_FEATURED_CATEGORIES}");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    //print(response.body.toString());
    //print("--featured cat--");
    print(response.body);
    return categoryResponseFromJson(response.body);
  }

  Future<CategoryResponse> getTopCategories() async {
    Uri url = Uri.parse("${ENDP.TOP_CATEGORIES}");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    return categoryResponseFromJson(response.body);
  }

  Future<CategoryResponse> getFilterPageCategories() async {
    Uri url = Uri.parse("${ENDP.GET_CATEGORIES}");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    return categoryResponseFromJson(response.body);
  }
}
