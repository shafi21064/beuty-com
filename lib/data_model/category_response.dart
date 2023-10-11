// To parse this JSON data, do
//
//     final categoryResponse = categoryResponseFromJson(jsonString);
//https://app.quicktype.io/
import 'dart:convert';

CategoryResponse categoryResponseFromJson(String str) =>
    CategoryResponse.fromJson(json.decode(str));

String categoryResponseToJson(CategoryResponse data) =>
    json.encode(data.toJson());

class CategoryResponse {
  CategoryResponse({
    this.categories,
    this.success,
    this.status,
  });

  List<Category> categories;
  bool success;
  int status;

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      CategoryResponse(
        categories:
            List<Category>.from(json["data"].map((x) => Category.fromJson(x))),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(categories.map((x) => x.toJson())),
        "success": success,
        "status": status,
      };
}

class Category {
  Category({
    this.id,
    this.name,
    this.banner,
    this.icon,
    this.number_of_children,
    this.subCategories,
  });

  int id;
  String name;
  String banner;
  String icon;
  int number_of_children;
  List<SubCategory> subCategories;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        banner: json["banner"],
        icon: json["icon"],
        number_of_children: json["number_of_children"],
        subCategories: List<SubCategory>.from(
            json["sub_categories"].map((x) => SubCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "banner": banner,
        "icon": icon,
        "number_of_children": number_of_children,
        "sub_categories":
            List<dynamic>.from(subCategories.map((x) => x.toJson())),
      };
}

class SubCategory {
  SubCategory({
    this.name,
    this.slug,
    this.categoryTranslations,
  });

  String name;
  String slug;
  List<dynamic> categoryTranslations;

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        name: json["name"],
        slug: json["slug"],
        categoryTranslations:
            List<dynamic>.from(json["category_translations"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
        "category_translations":
            List<dynamic>.from(categoryTranslations.map((x) => x)),
      };
}
