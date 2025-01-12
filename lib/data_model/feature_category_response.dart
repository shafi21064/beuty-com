import 'dart:convert';

class FeaturedCategory {
  int id;
  String icon;
  String banner;
  dynamic isTop;
  dynamic isFeatured;
  String name;
  String slug;
  dynamic disabled;
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

  @override
  String toString() {
    return 'FeaturedCategory{id: $id, name: $name}';
  }
}

List<FeaturedCategory> featuredCategoryListFromJson(String jsonString){
  final List<dynamic> jsonList = json.decode(jsonString);
  return jsonList.map((json) => FeaturedCategory.fromJson(json)).toList();
}


