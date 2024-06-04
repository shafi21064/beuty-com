import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kirei/screens/recomendation_pages/question_and_value.dart';
import 'package:kirei/screens/recomendation_pages/question_model.dart';
import 'package:one_context/one_context.dart';

import 'screeen/skin_care_history/recomedation_screen_one.dart';

class RecommendationController with ChangeNotifier {
  RecommendationQuestionAndAns _questions = RecommendationQuestionAndAns.fromJson(recommendationQuestionAndAns);
  RecommendationQuestionAndAns get questions => _questions;
  int _radioButtonSelectedValue;
  int get radioButtonSelectedValue => _radioButtonSelectedValue;

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
  String selectedAge;
  String selectedGender;
  String selectedAlergy;
  String selectedPregnant;
  String selectedRational;
  String selectedBasicSkinCare;
  String selectedFollowingSkinCare;
  String selectedSkinSensitive;
  String selectedSkinBurning;
  String selectedSkinIrritate;


  /// Skin Care Goal
  List skinCareConcern;


  onNextTap(){
    if(skinHistoryProgress < 0.9999999999999999
    ) {
      skinHistoryProgress = skinHistoryProgress + (1/10);
      progressValue += 1;
      questionIndex += 1;

      if (skinHistoryProgress == 1) {
        skinGoalProgress = skinGoalProgress + 0.1;
      }
    }
    print(selectedAge);
    print(skinHistoryProgress);

    if(progressValue > 5){
      OneContext().push(MaterialPageRoute(builder: (_)=> RecomendationScreen()));
      return;
    }
    print(skinHistoryProgress);

    notifyListeners();
  }

  onBackTap(){
    if(skinHistoryProgress > 0.2 ){
    skinHistoryProgress = skinHistoryProgress - 0.1;
    if(skinGoalProgress < 0.1){
      skinGoalProgress += 0.1;
    }
    progressValue -= 1;
    questionIndex -=1 ;
    }
    print(selectedAge);
    OneContext().pop();
    notifyListeners();
  }


  // void selectOption(int index, String option) {
  //   _questions[index].selectedOption = option;
  //   notifyListeners();
  // }
  //
  // Map<String, String> getResponses() {
  //   return {for (var q in _questions) q.question: q.selectedOption};
  // }
}
