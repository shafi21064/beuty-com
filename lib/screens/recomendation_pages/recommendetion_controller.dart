import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kirei/screens/recomendation_pages/model/products_response.dart';
import 'package:kirei/screens/recomendation_pages/question_and_value.dart';
import 'package:kirei/screens/recomendation_pages/question_model.dart';
import 'package:one_context/one_context.dart';


class RecommendationController with ChangeNotifier {
  RecommendationQuestionAndAns _questions = RecommendationQuestionAndAns.fromJson(recommendationQuestionAndAns);
  RecommendationQuestionAndAns get questions => _questions;
  int _radioButtonSelectedValue;
  int get radioButtonSelectedValue => _radioButtonSelectedValue;
  RecommendationProductResponse productResponse = RecommendationProductResponse();

  setRadioButtonValue(int value){
    _radioButtonSelectedValue = value;
    notifyListeners();
  }

  double skinHistoryProgress = 1 / 10;
  double skinGoalProgress = 0;
  int progressValue = 1;
  double maximumProgressValue = 10;
  int questionIndex = 0;

  /// Skin Care History
  String selectedAge = '';
  String selectedGender = '';
  String selectedAlergy = '';
  String selectedPregnant = '';
  String selectedRational = '';
  String selectedBasicSkinCare = '';
  String selectedFollowingSkinCare = '';
  String selectedSkinSensitive = '';
  String selectedSkinBurning = '';
  String selectedSkinIrritate = '';


  /// Skin Care Goal
  List skinCareConcern = [];
  String selectedSkinType = '';


  ///Acne
  String acneOneSelected = '';
  String acneTwoSelected = '';
  String acneThreeSelected = '';
  String acneFourSelected = '';
  String acneFiveSelected = '';

  /// Anti-Aging
  String agingOneSelected = '';
  String agingTwoSelected = '';
  String agingThreeSelected = '';

  ///BlackHeads
  String blackHeadsOneSelected = '';
  String blackHeadsTwoSelected = '';
  String blackHeadsThreeSelected = '';

  ///Hypigmentation
  String pigmentationOneSelected = '';
  String pigmentationTwoSelected = '';
  List pigmentationThreeSelected = [];
  String pigmentationFourSelected = '';
  List pigmentationFiveSelected = [];

  ///Dullness
  String dullnessOneSelected = '';

  /// Dehydred
  String dehydredOneSelected = '';
  String dehydredTwoSelected = '';



  Future<void> onRefresh()async {
     return print('refresh');
  }


  Map<String, dynamic> formatDataToJson() {
    return {
      "gaip_user_id": null,
      "questions": {
        "skincare_history": {
          "q1": selectedAge,
          "q2": selectedGender,
          "q3": selectedAlergy,
          "q4": selectedPregnant,
          "q5": selectedRational,
          "q6": selectedBasicSkinCare,
          "q7": selectedFollowingSkinCare.split(',').map((e) => e.trim()).toList(),
        },
        "sensitivity_related": {
          "q8": selectedSkinSensitive,
          "q9": selectedSkinBurning,
          "q10": selectedSkinIrritate,
        },
        "skincare_goal": {
          "q1": skinCareConcern,
          "q2": selectedSkinType,
          "q3": "",
          "q4": "",
          "q5": "",
          "q6": "",
        },
        "acne_targeting_questions": {
          "q1": acneOneSelected,
          "q2": acneTwoSelected,
          "q3": acneThreeSelected,
          "q4": acneFourSelected,
          "q5": acneFiveSelected,
        },
        "anti_aging_related": {
          "q1": agingOneSelected,
          "q2": agingTwoSelected,
          "q3": agingThreeSelected,
        },
        "closed_comedones_blackheads_whiteheads_related_questions": {
          "q4": blackHeadsOneSelected,
          "q5": blackHeadsTwoSelected,
          "q6": blackHeadsThreeSelected,
        },
        "hyperpigmentation_and_dark_spots_related_questions": {
          "q7": pigmentationOneSelected,
          "q8": pigmentationTwoSelected,
          "q9": pigmentationThreeSelected,
          "q10": pigmentationFourSelected,
          "q11": pigmentationFiveSelected,
        },
        "dullness_related_questions": {
          "q12": dullnessOneSelected,
        },
        "dehydrated_skin_related_questions": {
          "q13": dehydredOneSelected,
          "q14": dehydredTwoSelected,
        },
      },
      "order_by": "default",
      "per_page": 24,
      "page": 1
    };
  }




  Future<RecommendationProductResponse> sendData() async {
    // Replace this with your API endpoint
    String url = 'https://app.kireibd.com/api/v2/gigalogy/questions/recommend';

    // Create the formatted data
    Map<String, dynamic> formattedData = formatDataToJson();

    // Send the POST request
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(formattedData),
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      var responseData = jsonDecode(response.body);
      print('Response data: $responseData');
      return productResponse = RecommendationProductResponse.fromJson(responseData);
    } else {
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('Failed to send data');
    }
  }


  // onNextTap(){
  //   if(skinHistoryProgress < 0.9999999999999999
  //   ) {
  //     skinHistoryProgress = skinHistoryProgress + (1/10);
  //     progressValue += 1;
  //     questionIndex += 1;
  //
  //     if (skinHistoryProgress == 1) {
  //       skinGoalProgress = skinGoalProgress + 0.1;
  //     }
  //   }
  //   print(selectedAge);
  //   print(skinHistoryProgress);
  //
  //   if(progressValue > 5){
  //     OneContext().push(MaterialPageRoute(builder: (_)=> RecomendationScreenAcne()));
  //     return;
  //   }
  //   print(skinHistoryProgress);
  //
  //   notifyListeners();
  // }
  //
  // onBackTap(){
  //   if(skinHistoryProgress > 0.2 ){
  //   skinHistoryProgress = skinHistoryProgress - 0.1;
  //   if(skinGoalProgress < 0.1){
  //     skinGoalProgress += 0.1;
  //   }
  //   progressValue -= 1;
  //   questionIndex -=1 ;
  //   }
  //   print(selectedAge);
  //   OneContext().pop();
  //   notifyListeners();
  // }


  // void selectOption(int index, String option) {
  //   _questions[index].selectedOption = option;
  //   notifyListeners();
  // }
  //
  // Map<String, String> getResponses() {
  //   return {for (var q in _questions) q.question: q.selectedOption};
  // }
}
