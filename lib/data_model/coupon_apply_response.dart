// To parse this JSON data, do
//
//     final couponApplyResponse = couponApplyResponseFromJson(jsonString);

import 'dart:convert';

CouponApplyResponse couponApplyResponseFromJson(String str) => CouponApplyResponse.fromJson(json.decode(str));

String couponApplyResponseToJson(CouponApplyResponse data) => json.encode(data.toJson());

class CouponApplyResponse {
  CouponApplyResponse({
    this.result,
    this.message,
    this.copon
  });

  bool result;
  String message;
  var copon;

  factory CouponApplyResponse.fromJson(Map<String, dynamic> json) => CouponApplyResponse(
    result: json["success"],
    message: json["message"],
    copon: json["coupon"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "coupon": copon,
  };
}