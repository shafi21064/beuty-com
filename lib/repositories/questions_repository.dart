import 'dart:convert';

import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/question_response_submit.dart';
import 'package:active_ecommerce_flutter/data_model/questions_response.dart';
import 'package:http/http.dart' as http;

import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter/foundation.dart';

class QuestionsRepository {
  Future<QuestionsResponse> getQuestionResponse(@required int product_id,
      {page = 1}) async {
    Uri url =
        Uri.parse("${AppConfig.BASE_URL}/product-questions/${product_id}");
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "App-Language": app_language.$,
      },
    );
    return questionsResponseFromJson(response.body);
  }

  Future<QuestionSubmitResponse> getQuestionSubmitResponse(
    @required int product_id,
    @required String name,
    @required String question,
  ) async {
    var post_body = jsonEncode(
        {"product_id": "${product_id}", "name": "$name", "text": "$question"});

    Uri url = Uri.parse("${AppConfig.BASE_URL}/product-question");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);

    return questionSubmitResponseFromJson(response.body);
  }
}
