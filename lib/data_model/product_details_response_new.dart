// To parse this JSON data, do
//
//     final productDetailsResponse = productDetailsResponseFromJson(jsonString);
// https://app.quicktype.io/
import 'dart:convert';

ProductDetailsResponse productDetailsResponseFromJson(String str) =>
    ProductDetailsResponse.fromJson(json.decode(str));

String productDetailsResponseToJson(ProductDetailsResponse data) =>
    json.encode(data.toJson());

class ProductDetailsResponse {
  ProductDetailsResponse({
    this.detailed_products,
    this.success,
    this.status,
  });

  DetailedProduct detailed_products;
  bool success;
  int status;

  factory ProductDetailsResponse.fromJson(Map<String, dynamic> json) =>
      ProductDetailsResponse(
        detailed_products: DetailedProduct.fromJson(json["data"]),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": detailed_products.toJson(),
        "success": success,
        "status": status,
      };
}

class DetailedProduct {
  DetailedProduct({
    this.id,
    this.name,
    this.slug,
    this.price,
    this.sku,
    this.stock,
    this.shortDescription,
    this.description,
    this.guide,
    this.skinTypes,
    this.keyIngredients,
    this.goodFor,
    this.preorderAmount,
    this.preorderAvailable,
    this.requestAvailable,
    this.preorderDeliveryDate,
    this.salePrice,
    this.saleCount,
    this.ratings,
    this.reviews,
    this.isHot,
    this.sideFeatured,
    this.isSale,
    this.isNew,
    this.isOutOfStock,
    this.releaseDate,
    this.developer,
    this.publisher,
    this.gameMode,
    this.rated,
    this.until,
    this.productCategories,
    this.productBrands,
    this.productTags,
    this.pictures,
    this.largePictures,
    this.smallPictures,
    this.stockQuantity,
    this.product_link,
  });

  int id;
  String name;
  String slug;
  int price;
  String sku;
  int stock;
  String shortDescription;
  dynamic description;
  String guide;
  List<SkinType> skinTypes;
  List<KeyIngredient> keyIngredients;
  List<GoodFor> goodFor;
  dynamic preorderAmount;
  int preorderAvailable;
  int requestAvailable;
  String preorderDeliveryDate;
  int salePrice;
  int saleCount;
  dynamic ratings;
  int reviews;
  int isHot;
  dynamic sideFeatured;
  bool isSale;
  int isNew;
  dynamic isOutOfStock;
  dynamic releaseDate;
  dynamic developer;
  dynamic publisher;
  dynamic gameMode;
  dynamic rated;
  dynamic until;
  List<ProductCategory> productCategories;
  List<ProductBrand> productBrands;
  List<ProductTag> productTags;
  List<Picture> pictures;
  List<Picture> largePictures;
  List<Picture> smallPictures;
  int stockQuantity;
  String product_link;

  factory DetailedProduct.fromJson(Map<String, dynamic> json) =>
      DetailedProduct(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        price: json["price"],
        sku: json["sku"],
        stock: json["stock"],
        shortDescription: json["short_description"],
        description: json["description"],
        guide: json["guide"],
        skinTypes: List<SkinType>.from(
            json["skin_types"].map((x) => SkinType.fromJson(x))),
        keyIngredients: List<KeyIngredient>.from(
            json["key_ingredients"].map((x) => KeyIngredient.fromJson(x))),
        goodFor: List<GoodFor>.from(
            json["good_for"].map((x) => GoodFor.fromJson(x))),
        preorderAmount: json["preorder_amount"],
        preorderAvailable: json["preorder_available"],
        requestAvailable: json["request_available"],
        preorderDeliveryDate: json["preorder_delivery_date"],
        salePrice: json["sale_price"],
        saleCount: json["sale_count"],
        ratings: json["ratings"],
        reviews: json["reviews"],
        isHot: json["is_hot"],
        sideFeatured: json["side_featured"],
        isSale: json["is_sale"],
        isNew: json["is_new"],
        isOutOfStock: json["is_out_of_stock"],
        releaseDate: json["release_date"],
        developer: json["developer"],
        publisher: json["publisher"],
        gameMode: json["game_mode"],
        rated: json["rated"],
        until: json["until"],
        productCategories: List<ProductCategory>.from(
            json["product_categories"].map((x) => ProductCategory.fromJson(x))),
        productBrands:
            List<ProductBrand>.from(
            json["product_brands"].map((x) => ProductBrand.fromJson(x))),
        productTags: List<ProductTag>.from(
            (json["product_tags"] as List).map((x) => ProductTag.fromJson(x))),
        pictures: List<Picture>.from(
            json["pictures"].map((x) => Picture.fromJson(x))),
        largePictures: List<Picture>.from(
            json["large_pictures"].map((x) => Picture.fromJson(x))),
        smallPictures: List<Picture>.from(
            json["small_pictures"].map((x) => Picture.fromJson(x))),
        stockQuantity: json["stock_quantity"],
        product_link: json["product_link"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "price": price,
        "sku": sku,
        "stock": stock,
        "short_description": shortDescription,
        "description": description,
        "guide": guide,
        "skin_types": List<SkinType>.from(skinTypes.map((x) => x.toJson())),
        "key_ingredients":
            List<KeyIngredient>.from(keyIngredients.map((x) => x.toJson())),
        "good_for": List<GoodFor>.from(goodFor.map((x) => x.toJson())),
        "preorder_amount": preorderAmount,
        "preorder_available": preorderAvailable,
        "request_available": requestAvailable,
        "preorder_delivery_date": preorderDeliveryDate,
        "sale_price": salePrice,
        "sale_count": saleCount,
        "ratings": ratings,
        "reviews": reviews,
        "is_hot": isHot,
        "side_featured": sideFeatured,
        "is_sale": isSale,
        "is_new": isNew,
        "is_out_of_stock": isOutOfStock,
        "release_date": releaseDate,
        "developer": developer,
        "publisher": publisher,
        "game_mode": gameMode,
        "rated": rated,
        "until": until,
        "product_categories": List<ProductCategory>.from(
            productCategories.map((x) => x.toJson())),
        "product_brands": List<ProductBrand>.from(productBrands.map((x) => x.toJson())),
        "product_tags":
            List<ProductTag>.from(productTags.map((x) => x.toJson())),
        "pictures": List<Picture>.from(pictures.map((x) => x.toJson())),
        "large_pictures":
            List<dynamic>.from(largePictures.map((x) => x.toJson())),
        "small_pictures":
            List<dynamic>.from(smallPictures.map((x) => x.toJson())),
        "stock_quantity": stockQuantity,
        "product_link" : product_link,
      };
}

class ProductBrand {
  ProductBrand({
    this.name,
    this.slug,
    this.pivot,
  });

  String name;
  String slug;
  Pivot pivot;

  factory ProductBrand.fromJson(Map<String, dynamic> json) => ProductBrand(
        name: json["name"],
        slug: json["slug"],
        pivot: Pivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
        "pivot": pivot.toJson(),
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

class ProductTag {
  ProductTag({
    this.name,
    this.slug,
    this.pivot,
  });

  String name;
  String slug;
  Pivot pivot;

  factory ProductTag.fromJson(Map<String, dynamic> json) => ProductTag(
        name: json["name"],
        slug: json["slug"],
        pivot: Pivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
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

class SkinType {
  SkinType({
    this.name,
    this.slug,
    this.pivot,
  });

  String name;
  String slug;
  Pivot pivot;

  factory SkinType.fromJson(Map<String, dynamic> json) => SkinType(
        name: json["name"],
        slug: json["slug"],
        pivot: Pivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
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

class KeyIngredient {
  KeyIngredient({
    this.name,
    this.slug,
    this.pivot,
  });

  String name;
  String slug;
  Pivot pivot;

  factory KeyIngredient.fromJson(Map<String, dynamic> json) => KeyIngredient(
        name: json["name"],
        slug: json["slug"],
        pivot: Pivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
        "pivot": pivot.toJson(),
      };
}

class GoodFor {
  GoodFor({
    this.name,
    this.slug,
    this.pivot,
  });

  String name;
  String slug;
  Pivot pivot;

  factory GoodFor.fromJson(Map<String, dynamic> json) => GoodFor(
        name: json["name"],
        slug: json["slug"],
        pivot: Pivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
        "pivot": pivot.toJson(),
      };
}

class Brand {
  Brand({
    this.id,
    this.name,
    this.logo,
  });

  int id;
  String name;
  String logo;

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        id: json["id"],
        name: json["name"],
        logo: json["logo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "logo": logo,
      };
}

class Photo {
  Photo({
    this.variant,
    this.path,
  });

  String variant;
  String path;

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        variant: json["variant"],
        path: json["path"],
      );

  Map<String, dynamic> toJson() => {
        "variant": variant,
        "path": path,
      };
}

class ChoiceOption {
  ChoiceOption({
    this.name,
    this.title,
    this.options,
  });

  String name;
  String title;
  List<String> options;

  factory ChoiceOption.fromJson(Map<String, dynamic> json) => ChoiceOption(
        name: json["name"],
        title: json["title"],
        options: List<String>.from(json["options"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "title": title,
        "options": List<dynamic>.from(options.map((x) => x)),
      };
}
