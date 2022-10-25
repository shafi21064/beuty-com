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
    this.title,
    this.slug,
    this.categoryName,
    this.banner,
    this.shortDescription,
    this.description,
    this.video,
  });

  int id;
  String title;
  String slug;
  CategoryName categoryName;
  String banner;
  String shortDescription;
  String description;
  String video;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    slug: json["slug"],
    categoryName: categoryNameValues.map[json["category_name"]],
    banner: json["banner"],
    shortDescription: json["short_description"],
    description: json["description"],
    video: json["video"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "slug": slug,
    "category_name": categoryNameValues.reverse[categoryName],
    "banner": banner,
    "short_description": shortDescription,
    "description": description,
    "video": video,
  };
}

enum CategoryName { EXPERT_MASTERCLASS, CELEBRITY_BEAUTY_SECRETS, SKINCARE_SECRETS, HAIRCARE_AND_STYLING }

final categoryNameValues = EnumValues({
  "Celebrity Beauty Secrets": CategoryName.CELEBRITY_BEAUTY_SECRETS,
  "Expert Masterclass": CategoryName.EXPERT_MASTERCLASS,
  "Haircare And Styling": CategoryName.HAIRCARE_AND_STYLING,
  "Skincare Secrets": CategoryName.SKINCARE_SECRETS
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
