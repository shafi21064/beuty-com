// To parse this JSON data, do
//
//     final beautyBooksResponse = beautyBooksResponseFromJson(jsonString);

import 'dart:convert';

BeautyBooksResponse beautyBooksResponseFromJson(String str) => BeautyBooksResponse.fromJson(json.decode(str));

String beautyBooksResponseToJson(BeautyBooksResponse data) => json.encode(data.toJson());

class BeautyBooksResponse {
  BeautyBooksResponse({
    this.data,
    this.success,
    this.status,
  });

  List<Datum> data;
  bool success;
  int status;

  factory BeautyBooksResponse.fromJson(Map<String, dynamic> json) => BeautyBooksResponse(
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
    this.name,
    this.page,
    this.posts,
    this.date,
  });

  int id;
  String name;
  int page;
  List<Post> posts;
  String date;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    page: json["page"],
    posts: List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "page": page,
    "posts": List<dynamic>.from(posts.map((x) => x.toJson())),
    "date": date,
  };
}

class Post {
  Post({
    this.id,
    this.categoryId,
    this.title,
    this.slug,
    this.banner,
    this.shortDescription,
    this.description,
    this.order,
    this.isActive,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  int id;
  int categoryId;
  String title;
  String slug;
  String banner;
  String shortDescription;
  String description;
  int order;
  int isActive;
  dynamic createdBy;
  dynamic updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json["id"],
    categoryId: json["category_id"],
    title: json["title"],
    slug: json["slug"],
    banner: json["banner"],
    shortDescription: json["short_description"],
    description: json["description"],
    order: json["order"],
    isActive: json["is_active"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "title": title,
    "slug": slug,
    "banner": banner,
    "short_description": shortDescription,
    "description": description,
    "order": order,
    "is_active": isActive,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "deleted_at": deletedAt,
  };
}
