// To parse this JSON data, do
//
//     final communityCommentResponse = communityCommentResponseFromJson(jsonString);

import 'dart:convert';

CommunityCommentResponse communityCommentResponseFromJson(String str) => CommunityCommentResponse.fromJson(json.decode(str));

String communityCommentResponseToJson(CommunityCommentResponse data) => json.encode(data.toJson());

class CommunityCommentResponse {
  CommunityCommentResponse({
    this.data,
    this.success,
    this.status,
  });

  List<Datum> data;
  bool success;
  int status;

  factory CommunityCommentResponse.fromJson(Map<String, dynamic> json) => CommunityCommentResponse(
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
    this.comment,
    this.customerName,
    this.customerAvatar,
  });

  int id;
  String comment;
  dynamic customerName;
  dynamic customerAvatar;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    comment: json["comment"],
    customerName: json["customer_name"],
    customerAvatar: json["customer_avatar"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "comment": comment,
    "customer_name": customerName,
    "customer_avatar": customerAvatar,
  };
}
