import 'dart:convert';

class RecommendationProductResponse {
  bool result;
  List<ProductType> data;

  RecommendationProductResponse({this.result, this.data});

  factory RecommendationProductResponse.fromJson(Map<String, dynamic> json) {
    return RecommendationProductResponse(
      result: json['result'],
      data: (json['data'] as List<dynamic>).map((e) => ProductType.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class ProductType {
  String type;
  List<Product> products;

  ProductType({this.type, this.products});

  factory ProductType.fromJson(Map<String, dynamic> json) {
    return ProductType(
      type: json['type'],
      products: (json['products'] as List<dynamic>).map((e) => Product.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'products': products.map((e) => e.toJson()).toList(),
    };
  }
}

class Product {
  int id;
  String name;
  String slug;
  int price;
  int salePrice;
  int discount;
  String sku;
  int stock;
  String shortDescription;
  String description;
  String guide;
  List<SkinType> skinTypes;
  List<KeyIngredient> keyIngredients;
  List<GoodFor> goodFor;
  int preorderAvailable;
  String preorderDeliveryDate;
  int preorderAmount;
  String preorderStartDate;
  String preorderEndDate;
  int saleCount;
  dynamic ratings;
  int reviews;
  int isHot;
  bool isSale;
  int isNew;
  bool isOutOfStock;
  String releaseDate;
  String developer;
  String publisher;
  String gameMode;
  String rated;
  String until;
  List<ProductCategory> productCategories;
  List<ProductBrand> productBrands;
  List<ProductTag> productTags;
  String onlyTags;
  List<Picture> pictures;
  List<Picture> largePictures;
  List<Picture> smallPictures;
  List<Variant> variants;
  int isCouponApplicable;
  String metaImage;
  String metaTitle;
  String metaDescription;
  String metaTags;
  String productLink;

  Product({
    this.id,
    this.name,
    this.slug,
    this.price,
    this.salePrice,
    this.discount,
    this.sku,
    this.stock,
    this.shortDescription,
    this.description,
    this.guide,
    this.skinTypes,
    this.keyIngredients,
    this.goodFor,
    this.preorderAvailable,
    this.preorderDeliveryDate,
    this.preorderAmount,
    this.preorderStartDate,
    this.preorderEndDate,
    this.saleCount,
    this.ratings,
    this.reviews,
    this.isHot,
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
    this.onlyTags,
    this.pictures,
    this.largePictures,
    this.smallPictures,
    this.variants,
    this.isCouponApplicable,
    this.metaImage,
    this.metaTitle,
    this.metaDescription,
    this.metaTags,
    this.productLink,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      price: json['price'],
      salePrice: json['sale_price'],
      discount: json['discount'],
      sku: json['sku'],
      stock: json['stock'],
      shortDescription: json['short_description'],
      description: json['description'],
      guide: json['guide'],
      skinTypes: (json['skin_types'] as List<dynamic>).map((e) => SkinType.fromJson(e as Map<String, dynamic>)).toList(),
      keyIngredients: (json['key_ingredients'] as List<dynamic>).map((e) => KeyIngredient.fromJson(e as Map<String, dynamic>)).toList(),
      goodFor: (json['good_for'] as List<dynamic>).map((e) => GoodFor.fromJson(e as Map<String, dynamic>)).toList(),
      preorderAvailable: json['preorder_available'],
      preorderDeliveryDate: json['preorder_delivery_date'],
      preorderAmount: json['preorder_amount'],
      preorderStartDate: json['preorder_start_date'],
      preorderEndDate: json['preorder_end_date'],
      saleCount: json['sale_count'],
      ratings: json['ratings'],
      reviews: json['reviews'],
      isHot: json['is_hot'],
      isSale: json['is_sale'],
      isNew: json['is_new'],
      isOutOfStock: json['is_out_of_stock'],
      releaseDate: json['release_date'],
      developer: json['developer'],
      publisher: json['publisher'],
      gameMode: json['game_mode'],
      rated: json['rated'],
      until: json['until'],
      productCategories: (json['product_categories'] as List<dynamic>).map((e) => ProductCategory.fromJson(e as Map<String, dynamic>)).toList(),
      productBrands: (json['product_brands'] as List<dynamic>).map((e) => ProductBrand.fromJson(e as Map<String, dynamic>)).toList(),
      productTags: (json['product_tags'] as List<dynamic>).map((e) => ProductTag.fromJson(e as Map<String, dynamic>)).toList(),
      onlyTags: json['only_tags'],
      pictures: (json['pictures'] as List<dynamic>).map((e) => Picture.fromJson(e as Map<String, dynamic>)).toList(),
      largePictures: (json['large_pictures'] as List<dynamic>).map((e) => Picture.fromJson(e as Map<String, dynamic>)).toList(),
      smallPictures: (json['small_pictures'] as List<dynamic>).map((e) => Picture.fromJson(e as Map<String, dynamic>)).toList(),
      //variants: (json['variants'] as List<dynamic>).map((e) => Variant.fromJson(e as Map<String, dynamic>)).toList(),
      isCouponApplicable: json['is_coupon_applicable'],
      metaImage: json['meta_image'],
      metaTitle: json['meta_title'],
      metaDescription: json['meta_description'],
      metaTags: json['meta_tags'],
      productLink: json['product_link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'price': price,
      'sale_price': salePrice,
      'discount': discount,
      'sku': sku,
      'stock': stock,
      'short_description': shortDescription,
      'description': description,
      'guide': guide,
      'skin_types': skinTypes.map((e) => e.toJson()).toList(),
      'key_ingredients': keyIngredients.map((e) => e.toJson()).toList(),
      'good_for': goodFor.map((e) => e.toJson()).toList(),
      'preorder_available': preorderAvailable,
      'preorder_delivery_date': preorderDeliveryDate,
      'preorder_amount': preorderAmount,
      'preorder_start_date': preorderStartDate,
      'preorder_end_date': preorderEndDate,
      'sale_count': saleCount,
      'ratings': ratings,
      'reviews': reviews,
      'is_hot': isHot,
      'is_sale': isSale,
      'is_new': isNew,
      'is_out_of_stock': isOutOfStock,
      'release_date': releaseDate,
      'developer': developer,
      'publisher': publisher,
      'game_mode': gameMode,
      'rated': rated,
      'until': until,
      'product_categories': productCategories.map((e) => e.toJson()).toList(),
      'product_brands': productBrands.map((e) => e.toJson()).toList(),
      'product_tags': productTags.map((e) => e.toJson()).toList(),
      'only_tags': onlyTags,
      'pictures': pictures.map((e) => e.toJson()).toList(),
      'large_pictures': largePictures.map((e) => e.toJson()).toList(),
      'small_pictures': smallPictures.map((e) => e.toJson()).toList(),
      //'variants': variants.map((e) => e.toJson()).toList(),
      'is_coupon_applicable': isCouponApplicable,
      'meta_image': metaImage,
      'meta_title': metaTitle,
      'meta_description': metaDescription,
      'meta_tags': metaTags,
      'product_link': productLink,
    };
  }
}

class SkinType {
  String name;
  String slug;
  Pivot pivot;

  SkinType({this.name, this.slug, this.pivot});

  factory SkinType.fromJson(Map<String, dynamic> json) {
    return SkinType(
      name: json['name'],
      slug: json['slug'],
      pivot: Pivot.fromJson(json['pivot']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'pivot': pivot.toJson(),
    };
  }
}

class KeyIngredient {
  String name;
  String slug;
  Pivot pivot;

  KeyIngredient({this.name, this.slug, this.pivot});

  factory KeyIngredient.fromJson(Map<String, dynamic> json) {
    return KeyIngredient(
      name: json['name'],
      slug: json['slug'],
      pivot: Pivot.fromJson(json['pivot']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'pivot': pivot.toJson(),
    };
  }
}

class GoodFor {
  String name;
  String slug;
  Pivot pivot;

  GoodFor({this.name, this.slug, this.pivot});

  factory GoodFor.fromJson(Map<String, dynamic> json) {
    return GoodFor(
      name: json['name'],
      slug: json['slug'],
      pivot: Pivot.fromJson(json['pivot']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'pivot': pivot.toJson(),
    };
  }
}

class Pivot {
  int productId;
  int productTagId;

  Pivot({this.productId, this.productTagId});

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      productId: json['product_id'],
      productTagId: json['product_tag_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_tag_id': productTagId,
    };
  }
}

class ProductCategory {
  String name;
  String slug;
  int parentName;
  Pivot pivot;

  ProductCategory({this.name, this.slug, this.parentName, this.pivot});

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      name: json['name'],
      slug: json['slug'],
      parentName: json['parent_name'],
      pivot: Pivot.fromJson(json['pivot']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'parent_name': parentName,
      'pivot': pivot.toJson(),
    };
  }
}

class ProductBrand {
  String name;
  String slug;
  Pivot pivot;

  ProductBrand({this.name, this.slug, this.pivot});

  factory ProductBrand.fromJson(Map<String, dynamic> json) {
    return ProductBrand(
      name: json['name'],
      slug: json['slug'],
      pivot: Pivot.fromJson(json['pivot']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'pivot': pivot.toJson(),
    };
  }
}

class ProductTag {
  String name;
  String slug;
  Pivot pivot;

  ProductTag({this.name, this.slug, this.pivot});

  factory ProductTag.fromJson(Map<String, dynamic> json) {
    return ProductTag(
      name: json['name'],
      slug: json['slug'],
      pivot: Pivot.fromJson(json['pivot']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'pivot': pivot.toJson(),
    };
  }
}

class Picture {
  String url;
  int width;
  int height;
  PicturePivot pivot;

  Picture({this.url, this.width, this.height, this.pivot});

  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(
      url: json['url'],
      width: json['width'],
      height: json['height'],
      pivot: PicturePivot.fromJson(json['pivot']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'width': width,
      'height': height,
      'pivot': pivot.toJson(),
    };
  }
}

class PicturePivot {
  int relatedId;
  String uploadFileId;

  PicturePivot({this.relatedId, this.uploadFileId});

  factory PicturePivot.fromJson(Map<String, dynamic> json) {
    return PicturePivot(
      relatedId: json['related_id'],
      uploadFileId: json['upload_file_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'related_id': relatedId,
      'upload_file_id': uploadFileId,
    };
  }
}

class Variant {
  // Define the Variant properties and methods
}

// Example usage:
// void main() {
//   String jsonString = '{"result": true, "data": [{"type": "Facewash", "products": [{"id": 149, "name": "Cow brand Skin Life Facial Cleansing Foam Medicated Acne Care 130g", "slug": "cow-brand-skinlife-facial-cleansing-foam-medicated-acne-care-130g", "price": 1050, "sale_price": 1050, "discount": 0, "sku": "KBD-149", "stock": 0, "short_description": "<p>Skin Type: Acne-prone skin</p><ul><li>Skin Concerns: Acne</li><li>Gender:&nbsp;Unisex</li></ul><p>Designed for acne-prone skin, this medicated cleansing foam uses an oil-free formula to exfoliate, soothe and replenish skin. Boasts a floral and fruity scent.</p><ul><li>With plenty of creamy foam, tightly off the acne.</li><li>Give skin moist and refreshing with luscious moisture, prepare the texture on the unobtrusive skin of the pores.</li><li>Flexible extra horny around the pores, prepare to smooth skin.</li><li>Oil free, noncomedogenic genetic tested.</li><li>Scent of citrus floral.</li><li>Efficacy effect:</li><li>Cleanse extra sebum and clean pores.</li><li>Firmly sterilize up to the acne of the back of the pores, to prevent acne.</li></ul>", "description": "<p><strong>Category:</strong> Cosmetics/Skin care/ Face wash&nbsp;<br>&nbsp;</p><ul><li>Brand Name: Cow</li><li>Company: COW BRAND SOAP KYOSHINSHA CO., LTD</li><li>Origin of the Country: Japan</li><li>Weight: 130 gm</li></ul><p><br><strong>Ingredients</strong>&nbsp;<br><br><br>Myristic acid, lauric acid, stearic acid,Isopropyl methylphenol, 2K glycyrrhizinate, behenic acid, K liquid methyltaurate coconut oil, Centella asiatica extract, Na-2 hyaluronic acid, papain, coix seed extract, dextrin, Glycerin, BG, distearyldimethylammonium hectorite, citric acid, fragrance, potassium hydroxide, methylparaben</p><p><br>&nbsp;</p>", "guide": "<p><strong>Use:</strong></p><p>After wetting your hands, take a pea size amount of facewash on the palm of your hand</p><p>• Rub it between your palms to create foam</p><p>• Wash your face gently with the created foam&nbsp;</p><p>• Rinse thoroughly afterwards</p>", "skin_types": [{"name": "normal", "slug": "normal", "pivot": {"product_id": 149, "product_tag_id": 3}}], "key_ingredients": [{"name": "lauric acid", "slug": "lauric acid", "pivot": {"product_id": 149, "product_tag_id": 4}}], "good_for": [{"name": "acne", "slug": "acne", "pivot": {"product_id": 149, "product_tag_id": 4}}], "preorder_available": 0, "preorder_delivery_date": "20-04-2024", "preorder_amount": 1050, "preorder_start_date": "01-01-1970", "preorder_end_date": "05-06-2024", "sale_count": 3958, "ratings": 4.9, "reviews": 12, "is_hot": 0, "is_sale": false, "is_new": 0, "is_out_of_stock": null, "release_date": null, "developer": null, "publisher": null, "game_mode": null, "rated": null, "until": null, "product_categories": [{"name": "Facewash", "slug": "facewash", "parent_name": 1, "pivot": {"product_id": 149, "product_category_id": 9}}], "product_brands": [{"name": "Cow brand", "slug": "Cow-brand-InnHu", "pivot": {"product_id": 149, "product_brand_id": 23}}], "product_tags": [{"name": "Pregnancy safe", "slug": "Pregnancy safe", "pivot": {"product_id": 149, "product_tag_id": 7}}], "only_tags": "Acne,Cow,facewash,Skinlife,Skin irritation,Mature skin,Teen skin,Pregnancy safe", "pictures": [{"url": "https://app.kireibd.com/storage/all/Cow-brand-SkinLife-03.png", "width": 800, "height": 800, "pivot": {"related_id": 149, "upload_file_id": "1660"}}], "large_pictures": [{"url": "https://app.kireibd.com/storage/all/Cow-brand-SkinLife-03.png", "width": 800, "height": 800, "pivot": {"related_id": 149, "upload_file_id": "1660"}}], "small_pictures": [{"url": "https://app.kireibd.com/storage/all/Cow-brand-SkinLife-03.png", "width": 800, "height": 800, "pivot": {"related_id": 149, "upload_file_id": "1660"}}], "variants": [], "is_coupon_applicable": 1, "meta_image": "https://app.kireibd.com/storage/2020/03/Skin-Life-Medicated-Face-Wash-Foam.png", "meta_title": "Cow brand SkinLife | Facial Cleansing Foam | Medicated Acne Care | 130g", "meta_description": "Category: Cosmetics/Skin care/ Face wash\r\n\r\n \tBrand Name: Cow\r\n \tCompany: COW BRAND SOAP KYOSHINSHA CO., LTD\r\n \tOrigin of the Country: Japan\r\n \tWeight: 130 gm\r\n\r\nIngredients\r\n\r\nIsopropyl methyl phenol ? glycyrrhulic acid 2K ? myristic acid ? lauric acid ? stearic acid ? behenic acid ? coconut oil fatty acid ? methyltaurine K solution ? DL-malic acid ? lemon extract ? glycerin ? BG ? distealyl dimethyl ammonium hectorite ? oxidized Ti? Citrate ? Fragrance ? K hydroxide\r\n\r\nUse\r\n\r\n \tTake an appropriate amount (about 2 cm) in the palm, use it whisking well.\r\n \tRinse thoroughly with water or lukewarm water.", "meta_tags": "Acne,Cow,facewash,Skinlife,Skin irritation,Mature skin,Teen skin,Pregnancy safe", "product_link": "https://kireibd.com/product/cow-brand-skinlife-facial-cleansing-foam-medicated-acne-care-130g"}]}]}';
//
//   Map<String, dynamic> jsonMap = jsonDecode(jsonString);
//
//   Response response = Response.fromJson(jsonMap);
//
//   print(response.result);
//   print(response.data[0].type);
//   print(response.data[0].products[0].name);
// }
