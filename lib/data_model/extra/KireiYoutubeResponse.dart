// To parse this JSON data, do
//
//     final kireiYoutubeResponse = kireiYoutubeResponseFromJson(jsonString);

import 'dart:convert';

KireiYoutubeResponse kireiYoutubeResponseFromJson(String str) => KireiYoutubeResponse.fromJson(json.decode(str));

String kireiYoutubeResponseToJson(KireiYoutubeResponse data) => json.encode(data.toJson());

class KireiYoutubeResponse {
  KireiYoutubeResponse({
    this.data,
    this.success,
    this.status,
  });

  List<Datum> data;
  bool success;
  int status;

  factory KireiYoutubeResponse.fromJson(Map<String, dynamic> json) => KireiYoutubeResponse(
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
    this.youtube,
    this.date,
  });

  int id;
  String name;
  List<Youtube> youtube;
  String date;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    youtube: List<Youtube>.from(json["youtube"].map((x) => Youtube.fromJson(x))),
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "youtube": List<dynamic>.from(youtube.map((x) => x.toJson())),
    "date": date,
  };
}

class Youtube {
  Youtube({
    this.id,
    this.categoryId,
    this.title,
    this.slug,
    this.banner,
    this.video,
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
  String video;
  String shortDescription;
  String description;
  int order;
  int isActive;
  dynamic createdBy;
  dynamic updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  factory Youtube.fromJson(Map<String, dynamic> json) => Youtube(
    id: json["id"],
    categoryId: json["category_id"],
    title: json["title"],
    slug: json["slug"],
    banner: json["banner"],
    video: json["video"],
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
    "video": video,
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
