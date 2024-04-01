import 'package:kirei/data_model/slider_response.dart';
import 'package:flutter/services.dart' show rootBundle;
class SlidersRepository {

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
