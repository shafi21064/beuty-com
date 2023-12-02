// To parse this JSON data, do
//
//     final brandResponse = brandResponseFromJson(jsonString);
// https://app.quicktype.io/
import 'dart:convert';

BrandResponse brandResponseFromJson(String str) =>
    BrandResponse.fromJson(json.decode(str));

String brandResponseToJson(BrandResponse data) => json.encode(data.toJson());

class BrandResponse {
  BrandResponse({
    this.brands,
    this.meta,
    this.success,
    this.status,
  });

  List<Brands> brands;
  Meta meta;
  bool success;
  int status;

  factory BrandResponse.fromJson(Map<String, dynamic> json) => BrandResponse(
        brands: List<Brands>.from(json["data"].map((x) => Brands.fromJson(x))),
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(brands.map((x) => x.toJson())),
        "meta": meta == null ? null : meta.toJson(),
        "success": success,
        "status": status,
      };
}

class Brands {
  Brands({
    this.id,
    this.is_top,
    this.slug,
    this.name,
    this.logo,
    this.links,
    this.title,
  });

  int id;
  int is_top;
  String title;
  String slug;
  String name;
  String logo;
  BrandsLinks links;

  factory Brands.fromJson(Map<String, dynamic> json) => Brands(
        name: json["name"],
        id: json["id"],
        is_top: json["is_top"],
        title: json["title"],
        slug: json["slug"],
        logo: json["logo"],
        links: BrandsLinks.fromJson(json["links"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "is_top": is_top,
        "slug": slug,
        "logo": logo,
        "titile": title,
        "links": links.toJson(),
      };
}

class BrandsLinks {
  BrandsLinks({
    this.products,
  });

  String products;

  factory BrandsLinks.fromJson(Map<String, dynamic> json) => BrandsLinks(
        products: json["products"],
      );

  Map<String, dynamic> toJson() => {
        "products": products,
      };
}

class Meta {
  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  int currentPage;
  int from;
  int lastPage;
  String path;
  int perPage;
  int to;
  int total;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        currentPage: json["current_page"],
        from: json["from"],
        lastPage: json["last_page"],
        path: json["path"],
        perPage: json["per_page"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "from": from,
        "last_page": lastPage,
        "path": path,
        "per_page": perPage,
        "to": to,
        "total": total,
      };
}
