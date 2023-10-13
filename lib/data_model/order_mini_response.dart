// To parse this JSON data, do
//
//     final orderMiniResponse = orderMiniResponseFromJson(jsonString);

import 'dart:convert';

OrderMiniResponse orderMiniResponseFromJson(String str) =>
    OrderMiniResponse.fromJson(json.decode(str));

String orderMiniResponseToJson(OrderMiniResponse data) =>
    json.encode(data.toJson());

class OrderMiniResponse {
  OrderMiniResponse({
    this.data,
    this.success,
    this.status,
  });

  List<Datum> data;
  bool success;
  int status;

  factory OrderMiniResponse.fromJson(Map<String, dynamic> json) =>
      OrderMiniResponse(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "success": success,
        "status": status,
      };
}

class Datum {
  Datum({
    this.id,
    this.shippingAddress,
    this.userId,
    this.paymentType,
    this.paymentStatus,
    this.paymentStatusString,
    this.deliveryStatus,
    this.couponCode,
    this.couponDiscount,
    this.shippingCost,
    this.deliveryStatusString,
    this.grandTotal,
    this.subtotal,
    this.date,
    this.links,
  });

  int id;
  ShippingAddress shippingAddress;
  int userId;
  String paymentType;
  String paymentStatus;
  String paymentStatusString;
  String deliveryStatus;
  dynamic couponCode;
  int couponDiscount;
  dynamic shippingCost;
  String deliveryStatusString;
  String grandTotal;
  int subtotal;
  String date;
  Links links;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        shippingAddress: ShippingAddress.fromJson(json["shipping_address"]),
        userId: json["user_id"],
        paymentType: json["payment_type"],
        paymentStatus: json["payment_status"],
        paymentStatusString: json["payment_status_string"],
        deliveryStatus: json["delivery_status"],
        couponCode: json["coupon_code"],
        couponDiscount: json["coupon_discount"],
        shippingCost: json["shipping_cost"],
        deliveryStatusString: json["delivery_status_string"],
        grandTotal: json["grand_total"],
        subtotal: json["subtotal"],
        date: json["date"],
        links: Links.fromJson(json["links"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "shipping_address": shippingAddress.toJson(),
        "user_id": userId,
        "payment_type": paymentType,
        "payment_status": paymentStatus,
        "payment_status_string": paymentStatusString,
        "delivery_status": deliveryStatus,
        "coupon_code": couponCode,
        "coupon_discount": couponDiscount,
        "shipping_cost": shippingCost,
        "delivery_status_string": deliveryStatusString,
        "grand_total": grandTotal,
        "subtotal": subtotal,
        "date": date,
        "links": links.toJson(),
      };
}

class Links {
  Links({
    this.details,
  });

  String details;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        details: json["details"],
      );

  Map<String, dynamic> toJson() => {
        "details": details,
      };
}

class ShippingAddress {
  ShippingAddress({
    this.name,
    this.email,
    this.address,
    this.country,
    this.state,
    this.city,
    this.postalCode,
    this.phone,
    this.stateId,
    this.cityId,
  });

  String name;
  String email;
  String address;
  String country;
  String state;
  String city;
  String postalCode;
  String phone;
  int stateId;
  int cityId;

  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      ShippingAddress(
        name: json["name"],
        email: json["email"],
        address: json["address"],
        country: json["country"],
        state: json["state"],
        city: json["city"],
        postalCode: json["postal_code"],
        phone: json["phone"],
        stateId: json["state_id"],
        cityId: (json["city_id"] is String)
            ? int.tryParse(json["city_id"]) ?? 0
            : json["city_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "address": address,
        "country": country,
        "state": state,
        "city": city,
        "postal_code": postalCode,
        "phone": phone,
        "state_id": stateId,
        "city_id": cityId,
      };
}
