// To parse this JSON data, do
//
//     final passwordForgetResponse = passwordForgetResponseFromJson(jsonString);

import 'dart:convert';

PasswordForgetResponse passwordForgetResponseFromJson(String str) => PasswordForgetResponse.fromJson(json.decode(str));

String passwordForgetResponseToJson(PasswordForgetResponse data) => json.encode(data.toJson());

class PasswordForgetResponse {
  PasswordForgetResponse({
    this.result,
    this.message,
    this.phone
  });

  bool result;
  String message;
String phone;
  factory PasswordForgetResponse.fromJson(Map<String, dynamic> json) => PasswordForgetResponse(
    result: json["result"],
    message: json["message"],
    phone: json["phone"]
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "phone":phone
  };
}