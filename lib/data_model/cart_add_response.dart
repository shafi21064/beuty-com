// To parse this JSON data, do
//
//     final cartAddResponse = cartAddResponseFromJson(jsonString);

import 'dart:convert';

CartAddResponse cartAddResponseFromJson(String str) => CartAddResponse.fromJson(json.decode(str));

String cartAddResponseToJson(CartAddResponse data) => json.encode(data.toJson());

class CartAddResponse {
  CartAddResponse({
    this.result,
    this.message,
    this.cart_quantity,
  });

  bool result;
  String message;
  int cart_quantity;

  factory CartAddResponse.fromJson(Map<String, dynamic> json) => CartAddResponse(
    result: json["result"],
    message: json["message"],
    cart_quantity: json["cart_quantity"]
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "cart_quantity": cart_quantity,
  };
}