// To parse this JSON data, do
//
//     final orderCreateResponse = orderCreateResponseCODFromJson(jsonString);

import 'dart:convert';

OrderCreateResponseCOD orderCreateResponseCODFromJson(String str) => OrderCreateResponseCOD.fromJson(json.decode(str));

String orderCreateResponseCODToJson(OrderCreateResponseCOD data) => json.encode(data.toJson());

class OrderCreateResponseCOD {
  OrderCreateResponseCOD({
    this.result,
    this.message,
    this.data,
    this.code,
  });

  bool result;
  String message;
  OrderData data;
  int code;

  factory OrderCreateResponseCOD.fromJson(Map<String, dynamic> json) => OrderCreateResponseCOD(
    result: json["result"],
    message: json["message"],
    data: json["data"] != null ? OrderData.fromJson(json["data"]) : null,
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "data": data != null ? data.toJson() : null,
    "code": code,
  };
}

class OrderData {
  OrderData({
    this.order,
    this.payment,
  });

  Order order;
  dynamic payment;

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
    order: json["order"] != null ? Order.fromJson(json["order"]) : null,
    payment: json["payment"],
  );

  Map<String, dynamic> toJson() => {
    "order": order != null ? order.toJson() : null,
    "payment": payment,
  };
}

class Order {
  Order({
    this.userId,
    this.apiCredentialId,
    this.shippingAddress,
    this.paymentType,
    this.paymentStatus,
    this.deliveryStatus,
    this.date,
    this.note,
    this.isRecurring,
    this.couponCode,
    this.grandTotal,
    this.couponDiscount,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  int userId;
  int apiCredentialId;
  String shippingAddress;
  String paymentType;
  String paymentStatus;
  int deliveryStatus;
  int date;
  dynamic note;
  int isRecurring;
  String couponCode;
  //int grandTotal;
  dynamic grandTotal;
  //int couponDiscount;
  dynamic couponDiscount;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    userId: json["user_id"],
    apiCredentialId: json["api_credential_id"],
    shippingAddress: json["shipping_address"], // Parse the string here if needed
    paymentType: json["payment_type"],
    paymentStatus: json["payment_status"],
    deliveryStatus: json["delivery_status"],
    date: json["date"],
    note: json["note"],
    isRecurring: json["is_recurring"],
    couponCode: json["coupon_code"],
    grandTotal: json["grand_total"],
    couponDiscount: json["coupon_discount"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "api_credential_id": apiCredentialId,
    "shipping_address": shippingAddress,
    "payment_type": paymentType,
    "payment_status": paymentStatus,
    "delivery_status": deliveryStatus,
    "date": date,
    "note": note,
    "is_recurring": isRecurring,
    "coupon_code": couponCode,
    "grand_total": grandTotal,
    "coupon_discount": couponDiscount,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "id": id,
  };
}

// class ShippingAddress {
//   ShippingAddress({
//     this.name,
//     this.address,
//     this.state,
//     this.city,
//     this.area,
//     this.phone,
//   });

//   String name;
//   String address;
//   String state;
//   String city;
//   dynamic area;
//   String phone;

//   factory ShippingAddress.fromJson(Map<String, dynamic> json) => ShippingAddress(
//     name: json["name"],
//     address: json["address"],
//     state: json["state"],
//     city: json["city"],
//     area: json["area"],
//     phone: json["phone"],
//   );

//   Map<String, dynamic> toJson() => {
//     "name": name,
//     "address": address,
//     "state": state,
//     "city": city,
//     "area": area,
//     "phone": phone,
//   };
// }
