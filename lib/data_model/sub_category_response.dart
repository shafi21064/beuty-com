// // To parse this JSON data, do
// //
// //     final categoryResponse = categoryResponseFromJson(jsonString);
// //https://app.quicktype.io/
// import 'dart:convert';
//
// CategoryResponse subCategoryResponseFromJson(String str) {
//   final jsonData = json.decode(str);
//   if (jsonData is List) {
//     // If the top-level structure is a list, create a dummy wrapper object.
//     return SubCategoryResponse(
//       categories: List<Category>.from(
//         jsonData.map((x) => Category.fromJson(x)),
//       ),
//       success: true, // Provide a default value for success.
//       status: 200, // Provide a default value for status.
//     );
//   } else if (jsonData is Map<String, dynamic>) {
//     // If the top-level structure is a map, proceed as usual.
//     return SubCategoryResponse.fromJson(jsonData);
//   } else {
//     // Handle other cases or throw an error.
//     throw FormatException("Invalid JSON format");
//   }
// }
//
// String subCategoryResponseToJson(SubCategoryResponse data) =>
//     json.encode(data.toJson());
//
// class SubCategoryResponse {
//   SubCategoryResponse({
//     this.categories,
//     this.success,
//     this.status,
//   });
//
//   List<Category> categories;
//   bool success;
//   int status;
//
//   factory SubCategoryResponse.fromJson(Map<String, dynamic> json) =>
//       SubCategoryResponse(
//         categories:
//             List<SubCategory>.from(json["data"].map((x) => SubCategory.fromJson(x))),
//         success: json["success"],
//         status: json["status"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "data": List<SubCategory>.from(categories.map((x) => x.toJson())),
//         "success": success,
//         "status": status,
//       };
// }
//
// class SubCategory {
//   SubCategory({
//     this.id,
//     this.icon,
//     this.banner,
//     this.isTop,
//     this.isFeatured,
//     this.name,
//     this.slug,
//     this.disabled,
//     this.counts,
//     this.children,
//   });
//
//   int id;
//   String icon;
//   String banner;
//   int isTop;
//   int isFeatured;
//   String name;
//   String slug;
//   bool disabled;
//   int counts;
//   List<SubCategory> children;
//
//   factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
//         id: json["id"],
//         icon: json["icon"],
//         banner: json["banner"],
//         isTop: json["is_top"],
//         isFeatured: json["is_featured"],
//         name: json["name"],
//         slug: json["slug"],
//         disabled: json["disabled"],
//         counts: json["counts"],
//         children: json["children"] != null
//             ? List<SubCategory>.from(
//                 json["children"].map((x) => SubCategory.fromJson(x)),
//               )
//             : [],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "icon": icon,
//         "banner": banner,
//         "is_top": isTop,
//         "is_featured": isFeatured,
//         "name": name,
//         "slug": slug,
//         "disabled": disabled,
//         "counts": counts,
//         "children": List<dynamic>.from(children.map((x) => x.toJson())),
//       };
// }
//
// class SCategory {
//   SubCategory({
//     this.id,
//     this.icon,
//     this.banner,
//     this.isTop,
//     this.isFeatured,
//     this.name,
//     this.slug,
//     this.disabled,
//     this.counts,
//   });
//
//   int id;
//   String icon;
//   String banner;
//   int isTop;
//   int isFeatured;
//   String name;
//   String slug;
//   bool disabled;
//   int counts;
//
//   factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
//         id: json["id"],
//         icon: json["icon"],
//         banner: json["banner"],
//         isTop: json["is_top"],
//         isFeatured: json["is_featured"],
//         name: json["name"],
//         slug: json["slug"],
//         disabled: json["disabled"],
//         counts: json["counts"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "icon": icon,
//         "banner": banner,
//         "is_top": isTop,
//         "is_featured": isFeatured,
//         "name": name,
//         "slug": slug,
//         "disabled": disabled,
//         "counts": counts,
//       };
// }
//
// // class SubCategory {
// //   SubCategory({
// //     this.name,
// //     this.slug,
// //     this.categoryTranslations,
// //   });
//
// //   String name;
// //   String slug;
// //   List<dynamic> categoryTranslations;
//
// //   factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
// //         name: json["name"],
// //         slug: json["slug"],
// //         categoryTranslations:
// //             List<dynamic>.from(json["category_translations"].map((x) => x)),
// //       );
//
// //   Map<String, dynamic> toJson() => {
// //         "name": name,
// //         "slug": slug,
// //         "category_translations":
// //             List<dynamic>.from(categoryTranslations.map((x) => x)),
// //       };
// // }
