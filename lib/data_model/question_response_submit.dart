// To parse this JSON data, do
//
//     final reviewSubmitResponse = reviewSubmitResponseFromJson(jsonString);

import 'dart:convert';

QuestionSubmitResponse questionSubmitResponseFromJson(String str) =>
    QuestionSubmitResponse.fromJson(json.decode(str));

String questionSubmitResponseToJson(QuestionSubmitResponse data) =>
    json.encode(data.toJson());

class QuestionSubmitResponse {
  QuestionSubmitResponse({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory QuestionSubmitResponse.fromJson(Map<String, dynamic> json) =>
      QuestionSubmitResponse(
        result: json["result"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "message": message,
      };
}
