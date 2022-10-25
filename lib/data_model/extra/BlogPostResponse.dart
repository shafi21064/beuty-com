// To parse this JSON data, do
//
//     final blogPostResponse = blogPostResponseFromJson(jsonString);

import 'dart:convert';

BlogPostResponse blogPostResponseFromJson(String str) => BlogPostResponse.fromJson(json.decode(str));

String blogPostResponseToJson(BlogPostResponse data) => json.encode(data.toJson());

class BlogPostResponse {
  BlogPostResponse({
    this.data,
    this.success,
    this.status,
  });

  Data data;
  bool success;
  int status;

  factory BlogPostResponse.fromJson(Map<String, dynamic> json) => BlogPostResponse(
    data: Data.fromJson(json["data"]),
    success: json["success"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "success": success,
    "status": status,
  };
}

class Data {
  Data({
    this.blogCategoryList,
    this.recentPosts,
    this.posts,
    this.totalCount,
  });

  List<BlogCategoryList> blogCategoryList;
  List<Post> recentPosts;
  List<Post> posts;
  int totalCount;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    blogCategoryList: List<BlogCategoryList>.from(json["blogCategoryList"].map((x) => BlogCategoryList.fromJson(x))),
    recentPosts: List<Post>.from(json["recentPosts"].map((x) => Post.fromJson(x))),
    posts: List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
    totalCount: json["totalCount"],
  );

  Map<String, dynamic> toJson() => {
    "blogCategoryList": List<dynamic>.from(blogCategoryList.map((x) => x.toJson())),
    "recentPosts": List<dynamic>.from(recentPosts.map((x) => x.toJson())),
    "posts": List<dynamic>.from(posts.map((x) => x.toJson())),
    "totalCount": totalCount,
  };
}

class BlogCategoryList {
  BlogCategoryList({
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

  factory BlogCategoryList.fromJson(Map<String, dynamic> json) => BlogCategoryList(
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
  };
}

class Post {
  Post({
    this.id,
    this.author,
    this.comments,
    this.content,
    this.date,
    this.slug,
    this.title,
    this.type,
    this.blogCategories,
    this.video,
    this.picture,
    this.smallPicture,
  });

  int id;
  String author;
  int comments;
  String content;
  DateTime date;
  String slug;
  String title;
  String type;
  List<BlogCategory> blogCategories;
  String video;
  List<Picture> picture;
  List<Picture> smallPicture;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json["id"],
    author: json["author"],
    comments: json["comments"],
    content: json["content"] == null ? null : json["content"],
    date: DateTime.parse(json["date"]),
    slug: json["slug"],
    title: json["title"],
    type: json["type"],
    blogCategories: List<BlogCategory>.from(json["blog_categories"].map((x) => BlogCategory.fromJson(x))),
    video: json["video"] == null ? null : json["video"],
    picture: List<Picture>.from(json["picture"].map((x) => Picture.fromJson(x))),
    smallPicture: List<Picture>.from(json["small_picture"].map((x) => Picture.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "author": author,
    "comments": comments,
    "content": content == null ? null : content,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "slug": slug,
    "title": title,
    "type": type,
    "blog_categories": List<dynamic>.from(blogCategories.map((x) => x.toJson())),
    "video": video == null ? null : video,
    "picture": List<dynamic>.from(picture.map((x) => x.toJson())),
    "small_picture": List<dynamic>.from(smallPicture.map((x) => x.toJson())),
  };
}

class BlogCategory {
  BlogCategory({
    this.name,
    this.slug,
    this.pivot,
  });

  String name;
  String slug;
  BlogCategoryPivot pivot;

  factory BlogCategory.fromJson(Map<String, dynamic> json) => BlogCategory(
    name: json["name"],
    slug: json["slug"],
    pivot: BlogCategoryPivot.fromJson(json["pivot"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "slug": slug,
    "pivot": pivot.toJson(),
  };
}

class BlogCategoryPivot {
  BlogCategoryPivot({
    this.blogId,
    this.blogCategoryId,
  });

  int blogId;
  int blogCategoryId;

  factory BlogCategoryPivot.fromJson(Map<String, dynamic> json) => BlogCategoryPivot(
    blogId: json["blog_id"],
    blogCategoryId: json["blog_category_id"],
  );

  Map<String, dynamic> toJson() => {
    "blog_id": blogId,
    "blog_category_id": blogCategoryId,
  };
}

class Picture {
  Picture({
    this.url,
    this.width,
    this.height,
    this.pivot,
  });

  dynamic url;
  int width;
  int height;
  PicturePivot pivot;

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
    url: json["url"],
    width: json["width"],
    height: json["height"],
    pivot: PicturePivot.fromJson(json["pivot"]),
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "width": width,
    "height": height,
    "pivot": pivot.toJson(),
  };
}

class PicturePivot {
  PicturePivot({
    this.relatedId,
    this.uploadFileId,
  });

  int relatedId;
  UploadFileId uploadFileId;

  factory PicturePivot.fromJson(Map<String, dynamic> json) => PicturePivot(
    relatedId: json["related_id"],
    uploadFileId: uploadFileIdValues.map[json["upload_file_id"]],
  );

  Map<String, dynamic> toJson() => {
    "related_id": relatedId,
    "upload_file_id": uploadFileIdValues.reverse[uploadFileId],
  };
}

enum UploadFileId { BLOGS_BANNER_1_JPG, BLOGS_BANNER_2_JPG, BLOGS_BANNER_3_JPG }

final uploadFileIdValues = EnumValues({
  "Blogs/banner_1.jpg": UploadFileId.BLOGS_BANNER_1_JPG,
  "Blogs/banner_2.jpg": UploadFileId.BLOGS_BANNER_2_JPG,
  "Blogs/banner_3.jpg": UploadFileId.BLOGS_BANNER_3_JPG
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
