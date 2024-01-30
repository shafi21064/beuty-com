// To parse this JSON data, do
//
//     final productMiniResponse = productMiniResponseFromJson(jsonString);
//https://app.quicktype.io/
import 'dart:convert';

ProductMiniResponse productMiniResponseFromJson(String str,
        {String key = "data"}) =>
    ProductMiniResponse.fromJson(json.decode(str), key: key);

String productMiniResponseToJson(ProductMiniResponse data) =>
    json.encode(data.toJson());

class ProductMiniResponse {
  ProductMiniResponse({
    this.products,
    this.meta,
    this.success,
    this.status,
  });

  List<Product> products;
  bool success;
  int status;
  Meta meta;

  factory ProductMiniResponse.fromJson(Map<String, dynamic> json,
      {String key = "data"}) {
    List<Product> productsList =
        List<Product>.from(json[key].map((x) => Product.fromJson(x)));

    return ProductMiniResponse(
      products: productsList,
      meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      success: json["success"],
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(products.map((x) => x.toJson())),
        "meta": meta == null ? null : meta.toJson(),
        "success": success,
        "status": status,
      };
}

class Product {
  Product({
    this.id,
    this.name,
    //this.thumbnail_image,
    this.price,
    this.sale_price,
    // this.has_discount,
    this.ratings,
    this.productCategories,
    this.pictures,
    this.slug,
    this.reviews,
    this.stock,
    // this.sales,
    // this.links,
  });

  int id;
  String name;
  //String thumbnail_image;
  int price;
  int sale_price;
  // bool has_discount;
  dynamic ratings;
  String slug;
  int reviews;
  int stock;
  // int sales;
  // Links links;
  List<ProductCategory> productCategories;
  List<Picture> pictures;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
      id: json["id"],
      name: json["name"],
      //thumbnail_image: json["thumbnail_image"],
      price: json["price"],
      sale_price: json["sale_price"],
      stock: json["stock"],
      // has_discount: json["has_discount"],
      ratings: json["ratings"],
      reviews: json["reviews"],
      productCategories: List<ProductCategory>.from(
          json["product_categories"].map((x) => ProductCategory.fromJson(x))),
      pictures:
          List<Picture>.from(json["pictures"].map((x) => Picture.fromJson(x))),
      slug: json["slug"]
      // sales: json["sales"],
      // links: Links.fromJson(json["links"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        //"thumbnail_image": thumbnail_image,
        "price": price,
        "sale_price": sale_price,
        "stock": stock,
        // "has_discount": has_discount,
        "ratings": ratings,
        "reviews": reviews,
        "slug": slug,
        "product_categories": List<ProductCategory>.from(
            productCategories.map((x) => x.toJson())),
        "pictures": List<Picture>.from(pictures.map((x) => x.toJson())),

        // "sales": sales,
        // "links": links.toJson(),
      };
}

class ProductCategory {
  ProductCategory({
    this.name,
    this.slug,
    this.parentName,
    this.pivot,
  });

  String name;
  String slug;
  dynamic parentName;
  Pivot pivot;

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      ProductCategory(
        name: json["name"],
        slug: json["slug"],
        parentName: json["parent_name"],
        pivot: Pivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
        "parent_name": parentName,
        "pivot": pivot.toJson(),
      };
}

class Picture {
  Picture({
    this.url,
    this.width,
    this.height,
    this.pivot,
  });

  String url;
  int width;
  int height;
  Pivot pivot;

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
        url: json["url"],
        width: json["width"],
        height: json["height"],
        pivot: Pivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "width": width,
        "height": height,
        "pivot": pivot.toJson(),
      };
}

class Pivot {
  Pivot({
    this.productId,
    this.productTagId,
  });

  int productId;
  int productTagId;

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        productId: json["product_id"],
        productTagId: json["product_tag_id"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_tag_id": productTagId,
      };
}

class Links {
  Links({
    this.details,
  });

  String details;

  factory Links.fromJson(Map<String, dynamic> json) => Links(
        details: json["details"],
      );

  Map<String, dynamic> toJson() => {
        "details": details,
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
