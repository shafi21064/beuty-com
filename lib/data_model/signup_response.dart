// To parse this JSON data, do
//
//     final signupResponse = signupResponseFromJson(jsonString);

import 'dart:convert';

import 'login_response.dart';

SignupResponse signupResponseFromJson(String str) =>
    SignupResponse.fromJson(json.decode(str));

String signupResponseToJson(SignupResponse data) => json.encode(data.toJson());

SignUpOtpResponse signUpOtpResponseFromJson(String str) =>
    SignUpOtpResponse.fromJson(json.decode(str));

String signUpOtpResponseToJson(SignUpOtpResponse data) =>
    json.encode(data.toJson());

class SignupResponse {
  SignupResponse(
      {this.result,
      this.message,
      this.user_id,
      this.access_token,
      this.token_type,
      this.user,
      this.phone});

  bool result;
  String message;
  int user_id;
  String access_token;
  String token_type;
  User user;
  String phone;

  factory SignupResponse.fromJson(Map<String, dynamic> json) => SignupResponse(
        result: json["result"],
        message: json["message"],
        user_id: json["user_id"],
        access_token:
            json["access_token"] == null ? null : json["access_token"],
        token_type: json["token_type"] == null ? null : json["token_type"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "message": message,
        "user_id": user_id,
        "access_token": access_token == null ? null : access_token,
        "token_type": token_type == null ? null : token_type,
        "user": user == null ? null : user.toJson(),
        "phone": phone
      };
}

class SignUpOtpResponse {
  SignUpOtpResponse({
    this.result,
    this.phone,
    this.message,
  });

  bool result;
  String phone;
  String message;

  factory SignUpOtpResponse.fromJson(Map<String, dynamic> json) =>
      SignUpOtpResponse(
        result: json['result'],
        phone: json['phone'],
        message: json['message'],
      );

  Map<String, dynamic> toJson() => {
        'result': result,
        'phone': phone,
        'message': message,
      };
}
