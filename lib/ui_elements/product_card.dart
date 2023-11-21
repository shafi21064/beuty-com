import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/screens/product_details.dart';
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductCard extends StatefulWidget {
  int id;
  //String image;
  String name;
  String price;
  String sale_price;
  dynamic ratings;
  String image;
  //bool has_discount;

  ProductCard({
    Key key,
    this.id,
    this.image,
    this.name,
    this.price,
    this.sale_price,
    this.ratings,
    //this.has_discount
  }) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    print((MediaQuery.of(context).size.width - 48) / 2);
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetails(
            id: widget.id,
          );
        }));
      },
      child: Container(
        //clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.09),
                spreadRadius: 0,
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ]),

        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  width: double.infinity,
                  //height: 158,
                  height: ((MediaQuery.of(context).size.width - 32) / 2),
                  child: ClipRRect(
                      clipBehavior: Clip.hardEdge,
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16), bottom: Radius.zero),
                      child: widget.image != null
                          ? FadeInImage.assetNetwork(
                              placeholder: 'assets/app_logo.png',
                              image: widget.image,
                              fit: BoxFit.fitWidth,
                            )
                          : Image.asset(
                              'assets/app_logo.png',
                              fit: BoxFit.fitWidth,
                            ))),
              Container(
                height: 90,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Text(
                        widget.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            color: MyTheme.font_grey,
                            fontSize: 14,
                            height: 1.2,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: RatingBar(
                        itemSize: 18.0,
                        ignoreGestures: true,
                        initialRating: double.parse(widget.ratings.toString()),
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        ratingWidget: RatingWidget(
                          full: Icon(FontAwesome.star, color: Colors.amber),
                          empty: Icon(FontAwesome.star,
                              color: Color.fromRGBO(224, 224, 225, 1)),
                        ),
                        itemPadding: EdgeInsets.only(right: 1.0),
                        onRatingUpdate: (rating) {
                          //print(rating);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 4, 16, 0),
                      child: Text(
                        "৳" + widget.sale_price,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            color: MyTheme.accent_color,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    // widget.has_discount
                    //     ?
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Text(
                        "৳" + widget.price,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: MyTheme.medium_grey,
                            fontSize: 11,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                    //: Container(),
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}
