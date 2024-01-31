import 'dart:convert';

class FeaturedCategory {
  int id;
  String icon;
  String banner;
  bool isTop;
  bool isFeatured;
  String name;
  String slug;
  bool disabled;
  String itemType;

  FeaturedCategory(
      {this.id,
      this.icon,
      this.banner,
      this.isTop,
      this.isFeatured,
      this.name,
      this.slug,
      this.disabled,
      this.itemType});

  factory FeaturedCategory.fromJson(Map<String, dynamic> json) {
    return FeaturedCategory(
      id: json['id'],
      icon: json['icon'],
      banner: json['banner'],
      isTop: json['is_top'],
      isFeatured: json['is_featured'],
      itemType: json['item_type'],
      name: json['name'],
      slug: json['slug'],
      disabled: json['disabled'],
    );
  }
}

List<FeaturedCategory> featuredCategoryListFromJson(String jsonString) {
  final List<dynamic> jsonList = json.decode(jsonString);
  return jsonList.map((json) => FeaturedCategory.fromJson(json)).toList();
}
