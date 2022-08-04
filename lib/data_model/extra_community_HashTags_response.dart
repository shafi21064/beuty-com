// To parse this JSON data, do
//
//     final communityHashtags = communityHashtagsFromJson(jsonString);

import 'dart:convert';

CommunityHashtags communityHashtagsFromJson(String str) => CommunityHashtags.fromJson(json.decode(str));

String communityHashtagsToJson(CommunityHashtags data) => json.encode(data.toJson());

class CommunityHashtags {
  CommunityHashtags({
    this.data,
    this.success,
    this.status,
  });

  List<Datum> data;
  bool success;
  int status;

  factory CommunityHashtags.fromJson(Map<String, dynamic> json) => CommunityHashtags(
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
  });

  int id;
  String title;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
  };
}
