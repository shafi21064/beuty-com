import 'package:flutter/material.dart';
import 'package:kirei/my_theme.dart';
import 'package:kirei/ui_elements/product_card.dart';
import 'package:kirei/repositories/product_repository.dart';
import 'package:kirei/helpers/shimmer_helper.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gradients/flutter_gradients.dart';

class TopSellingProducts extends StatefulWidget {
  @override
  _TopSellingProductsState createState() => _TopSellingProductsState();
}

class _TopSellingProductsState extends State<TopSellingProducts> {
  ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: buildAppBar(context),
        body: buildProductList(context),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            MyTheme.primary,
            Theme.of(context).colorScheme.secondary,
          ]),
        ),
      ),
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        "Products",
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  buildProductList(context) {
    return FutureBuilder(
        future: ProductRepository().getBestSellingProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            //snapshot.hasError
            print("product error");
            print(snapshot.error.toString());
            return Container();
          } else if (snapshot.hasData) {
            var productResponse = snapshot.data;
            print(productResponse.toString());
            return SingleChildScrollView(
              child: GridView.builder(
                // 2
                //addAutomaticKeepAlives: true,
                itemCount: productResponse.products.length,
                controller: _scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.618),
                padding: EdgeInsets.all(16),
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  // 3
                  return ProductCard(
                    id: productResponse.products[index].id,
                    name: productResponse.products[index].name,
                    price: productResponse.products[index].price.toString(),
                    sale_price:
                        productResponse.products[index].sale_price.toString(),
                    ratings: productResponse.products[index].ratings,
                    image: productResponse.products[index].pictures[0].url,
                    slug: productResponse.products[index].slug,

                    //image: productResponse.products[index].thumbnail_image,
                    //name: productResponse.products[index].name,
                    // main_price: productResponse.products[index].main_price,
                    // stroked_price:
                    //     productResponse.products[index].stroked_price,
                    // has_discount: productResponse.products[index].has_discount,
                  );
                },
              ),
            );
          } else {
            return ShimmerHelper()
                .buildProductGridShimmer(scontroller: _scrollController);
          }
        });
  }
}
