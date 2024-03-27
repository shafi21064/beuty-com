import 'package:kirei/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:kirei/data_model/slider_response.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:flutter/services.dart' show rootBundle;
class SlidersRepository {
  // Future<SliderResponse> getSliders() async {

  //   Uri url =  Uri.parse("${AppConfig.BASE_URL}/sliders");
  //   final response =
  //       await http.get(url,
  //         headers: {
  //           "App-Language": app_language.$,
  //         },);
  //   /*print(response.body.toString());
  //   print("sliders");*/
  //   return sliderResponseFromJson(response.body);
  // }

  Future<SliderResponse> getSliders() async {
  try {
    // Load the JSON file from the assets folder
    String jsonData = await rootBundle.loadString('assets/sliders.json');

    // Parse the JSON data
    SliderResponse sliderResponse = sliderResponseFromJson(jsonData);
    return sliderResponse;
  } catch (e) {
    // Handle any errors that occur during the process
    print('Error fetching sliders: $e');
    return null;
  }
}
}
