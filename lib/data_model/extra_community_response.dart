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
    this.isLiked,
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
  bool isLiked;
  int commentsCount;
  List<AllComment> allComments;

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
    isLiked: json["isLiked"],
    commentsCount: json["comments_count"],
    allComments: List<AllComment>.from(json["all_comments"].map((x) => AllComment.fromJson(x))),
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
    "isLiked": isLiked,
    "comments_count": commentsCount,
    "all_comments": List<dynamic>.from(allComments.map((x) => x.toJson())),
  };
}

class AllComment {
  AllComment({
    this.id,
    this.parentId,
    this.customerId,
    this.postId,
    this.comment,
    this.order,
    this.isActive,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.customerName,
  });

  int id;
  int parentId;
  int customerId;
  int postId;
  String comment;
  int order;
  int isActive;
  dynamic createdBy;
  dynamic updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  String customerName;

  factory AllComment.fromJson(Map<String, dynamic> json) => AllComment(
    id: json["id"],
    parentId: json["parent_id"] == null ? null : json["parent_id"],
    customerId: json["customer_id"],
    postId: json["post_id"],
    comment: json["comment"],
    order: json["order"],
    isActive: json["is_active"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    customerName: json["customer_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "parent_id": parentId == null ? null : parentId,
    "customer_id": customerId,
    "post_id": postId,
    "comment": comment,
    "order": order,
    "is_active": isActive,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "deleted_at": deletedAt,
    "customer_name": customerName,
  };
}
