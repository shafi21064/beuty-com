// To parse this JSON data, do
//
//     final communityPostResponse = communityPostResponseFromJson(jsonString);

import 'dart:convert';

CommunityPostResponse communityPostResponseFromJson(String str) => CommunityPostResponse.fromJson(json.decode(str));

String communityPostResponseToJson(CommunityPostResponse data) => json.encode(data.toJson());

class CommunityPostResponse {
  CommunityPostResponse({
    this.data,
    this.success,
    this.status,
  });

  List<Datum> data;
  bool success;
  int status;

  factory CommunityPostResponse.fromJson(Map<String, dynamic> json) => CommunityPostResponse(
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
    this.customerId,
    this.customerName,
    this.title,
    this.description,
    this.banner,
    this.hashtags,
    this.date,
    this.likeCount,
    this.commentsCount,
    this.allComments,
  });

  int id;
  int customerId;
  String customerName;
  String title;
  String description;
  String banner;
  String hashtags;
  String date;
  int likeCount;
  int commentsCount;
  List<dynamic> allComments;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    customerId: json["customer_id"],
    customerName: json["customer_name"],
    title: json["title"],
    description: json["description"],
    banner: json["banner"],
    hashtags: json["hashtags"],
    date: json["date"],
    likeCount: json["like_count"],
    commentsCount: json["comments_count"],
    allComments: List<dynamic>.from(json["all_comments"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "customer_id": customerId,
    "customer_name": customerName,
    "title": title,
    "description": description,
    "banner": banner,
    "hashtags": hashtags,
    "date": date,
    "like_count": likeCount,
    "comments_count": commentsCount,
    "all_comments": List<dynamic>.from(allComments.map((x) => x)),
  };
}
