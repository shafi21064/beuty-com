import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kirei/helpers/shimmer_helper.dart';
import 'package:kirei/screens/main.dart';
import 'package:kirei/screens/recomendation_pages/model/products_response.dart';
import 'package:kirei/screens/recomendation_pages/recommendetion_controller.dart';
import 'package:kirei/ui_elements/mini_product_card.dart';
import 'package:provider/provider.dart';
import '../../../my_theme.dart';

class RecommendedProducts extends StatefulWidget {
  const RecommendedProducts({Key key}) : super(key: key);

  @override
  State<RecommendedProducts> createState() => _RecommendedProductsState();
}

class _RecommendedProductsState extends State<RecommendedProducts> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecommendationController>(context, listen: false);
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildProductList(provider.productResponse),
    );
  }

  Container buildProductList(RecommendationProductResponse productResponse) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: buildProductScrollableList(productResponse),
          ),
        ],
      ),
    );
  }

  Widget buildProductScrollableList(RecommendationProductResponse productResponse) {
    if (productResponse.data == null) {
      return ShimmerHelper().buildProductGridShimmer(item_count: 20);
    } else if (productResponse.data.isNotEmpty) {
      return Container(
        child: Consumer<RecommendationController>(
          builder: (context, provider, child) {
            return RefreshIndicator(
              color: Colors.white,
              backgroundColor: MyTheme.primary,
              onRefresh: provider.onRefresh,
              child: ListView(
                children: productResponse.data.map<Widget>((productData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            productData.type,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 250,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: productData.products.length,
                            scrollDirection: Axis.horizontal,
                            itemExtent: MediaQuery.of(context).size.width / 2.5,
                            itemBuilder: (context, index) {
                              final product = productData.products[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 5, left: 5),
                                child: MiniProductCard(
                                  preorderAvailable: product.preorderAvailable,
                                  id: product.id,
                                  image: product.pictures.isNotEmpty ? product.pictures[0].url : '',
                                  ratings: product.ratings,
                                  name: product.name,
                                  price: product.price.toString(),
                                  sale_price: product.salePrice.toString(),
                                  slug: product.slug,
                                  reviews: product.reviews,
                                  stock: product.stock,
                                  discount: product.discount,
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 12,)
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          },
        ),
      );
    } else {
      return Center(child: Text('No Products available'));
    }
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: MyTheme.primary,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: MyTheme.white),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_)=> Main())),
      ),
      title: Text(
        'Ai Recommendation',
        style: TextStyle(fontSize: 16, color: MyTheme.white),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }
}
