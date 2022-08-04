// To parse this JSON data, do
//
//     final addCommunityLike = addCommunityLikeFromJson(jsonString);

import 'dart:convert';

AddCommunityLike addCommunityLikeFromJson(String str) => AddCommunityLike.fromJson(json.decode(str));

String addCommunityLikeToJson(AddCommunityLike data) => json.encode(data.toJson());

class AddCommunityLike {
  AddCommunityLike({
    this.result,
    this.message,
  });

  bool result;
  String message;

  factory AddCommunityLike.fromJson(Map<String, dynamic> json) => AddCommunityLike(
    result: json["result"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
  };
}
