// To parse this JSON data, do
//
//     final beautyBooksResponse = beautyBooksResponseFromJson(jsonString);

import 'dart:convert';

List<BeautyBooksResponse> beautyBooksResponseFromJson(String str) => List<BeautyBooksResponse>.from(json.decode(str).map((x) => BeautyBooksResponse.fromJson(x)));

String beautyBooksResponseToJson(List<BeautyBooksResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BeautyBooksResponse {
  BeautyBooksResponse({
    this.id,
    this.name,
    this.slug,
    this.order,
    this.isActive,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.books,
  });

  int id;
  String name;
  String slug;
  int order;
  int isActive;
  dynamic createdBy;
  dynamic updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  Books books;

  factory BeautyBooksResponse.fromJson(Map<String, dynamic> json) => BeautyBooksResponse(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    order: json["order"],
    isActive: json["is_active"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    books: Books.fromJson(json["books"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "order": order,
    "is_active": isActive,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "deleted_at": deletedAt,
    "books": books.toJson(),
  };
}

class Books {
  Books({
    this.data,
  });

  List<Datum> data;

  factory Books.fromJson(Map<String, dynamic> json) => Books(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.title,
    this.slug,
    this.categoryName,
    this.banner,
    this.shortDescription,
    this.description,
    this.links,
  });

  int id;
  String title;
  String slug;
  String categoryName;
  String banner;
  String shortDescription;
  String description;
  List<dynamic> links;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    slug: json["slug"],
    categoryName: json["category_name"],
    banner: json["banner"],
    shortDescription: json["short_description"],
    description: json["description"],
    links: List<dynamic>.from(json["links"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "slug": slug,
    "category_name": categoryName,
    "banner": banner,
    "short_description": shortDescription,
    "description": description,
    "links": List<dynamic>.from(links.map((x) => x)),
  };
}






