// To parse this JSON data, do
//
//     final SkinTypesResponse = SkinTypesResponseFromJson(jsonString);
// https://app.quicktype.io/
import 'dart:convert';

SkinTypesResponse skinTypesResponseFromJson(String str) =>
    SkinTypesResponse.fromJson(json.decode(str));

String skinTypesResponseToJson(SkinTypesResponse data) =>
    json.encode(data.toJson());

class SkinTypesResponse {
  SkinTypesResponse({
    this.skinTypes,
    this.success,
    this.status,
  });

  List<SkinTypes> skinTypes;

  bool success;
  int status;

  factory SkinTypesResponse.fromJson(Map<String, dynamic> json) =>
      SkinTypesResponse(
        skinTypes: List<SkinTypes>.from(
            json["data"].map((x) => SkinTypes.fromJson(x))),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(skinTypes.map((x) => x.toJson())),
        "success": success,
        "status": status,
      };
}

class SkinTypes {
  SkinTypes({
    this.id,
    this.slug,
    this.title,
  });

  int id;
  String title;
  String slug;

  factory SkinTypes.fromJson(Map<String, dynamic> json) => SkinTypes(
        id: json["id"],
        title: json["title"],
        slug: json["slug"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "slug": slug,
        "title": title,
      };
}
