// To parse this JSON data, do
//
//     final newCommunityPostResponse = newCommunityPostResponseFromJson(jsonString);

import 'dart:convert';

NewCommunityPostResponse newCommunityPostResponseFromJson(String str) => NewCommunityPostResponse.fromJson(json.decode(str));

String newCommunityPostResponseToJson(NewCommunityPostResponse data) => json.encode(data.toJson());

class NewCommunityPostResponse {
  NewCommunityPostResponse({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory NewCommunityPostResponse.fromJson(Map<String, dynamic> json) => NewCommunityPostResponse(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}
