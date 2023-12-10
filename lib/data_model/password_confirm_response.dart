// To parse this JSON data, do
//
//     final passwordConfirmResponse = passwordConfirmResponseFromJson(jsonString);

import 'dart:convert';

PasswordConfirmResponse passwordConfirmResponseFromJson(String str) => PasswordConfirmResponse.fromJson(json.decode(str));

String passwordConfirmResponseToJson(PasswordConfirmResponse data) => json.encode(data.toJson());

class PasswordConfirmResponse {
  PasswordConfirmResponse({
    this.result,
    this.message,
    this.phone,
  });

  bool result;
  String message;
  String phone;

  factory PasswordConfirmResponse.fromJson(Map<String, dynamic> json) => PasswordConfirmResponse(
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