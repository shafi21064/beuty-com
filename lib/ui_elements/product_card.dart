import 'package:kirei/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:kirei/screens/product_details.dart';
import 'package:kirei/app_config.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductCard extends StatefulWidget {
  int id;
  int stock;
  //String image;
  String name;
  String price;
  String sale_price;
  dynamic ratings;
  String image;
  String slug;
  dynamic reviews;
  //bool has_discount;

  ProductCard(
      {Key key,
      this.id,
      this.image,
      this.name,
      this.price,
      this.sale_price,
      this.ratings,
      this.reviews,
      this.slug,
      this.stock
      //this.has_discount
      })
      : super(key: key);

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
            slug: widget.slug,
          );
        }));
      },
      child: Container(
        //clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(0), boxShadow: [
          // BoxShadow(
          //   color: Colors.grey.withOpacity(0.09),
          //   spreadRadius: 0,
          //   blurRadius: 3,
          //   offset: Offset(0, 1),
          // ),
        ]),

        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(bottom: 8),
                  //height: 158,
                  height: ((MediaQuery.of(context).size.width - 32) / 2.5),
                  child: ClipRRect(
                      clipBehavior: Clip.hardEdge,
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(0), bottom: Radius.zero),
                      child: Container(
                          color: MyTheme.light_grey,
                          child: widget.image != null
                              ? FadeInImage.assetNetwork(
                                  placeholder: 'assets/app_logo.png',
                                  image: widget.image,
                                  fit: BoxFit.fill,
                                )
                              : Image.asset(
                                  'assets/app_logo.png',
                                  fit: BoxFit.fitWidth,
                                )))),
              Container(
                width: MediaQuery.of(context).size.width / 2 - .5,
                height: 40,
                child: RaisedButton(
                  onPressed: () {
                    // onPressAddToCart(context, _addedToCartSnackbar);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0)),
                  padding: EdgeInsets.all(0.0),
                  child: Ink(
                    // color: MyTheme.add_to_cart_button,
                    // decoration: BoxDecoration(color: MyTheme.add_to_cart_button
                    //
                    //     ),
                    child: Container(
                      color: widget.stock > 0
                          ? MyTheme.add_to_cart_button
                          : Color.fromRGBO(192, 53, 50, 1),
                      constraints:
                          BoxConstraints(maxWidth: 300.0, minHeight: 30.0),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: widget.stock > 0,
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              size: 15,
                              color: Colors.white, // Set the icon color
                            ),
                          ),
                          SizedBox(
                              width:
                                  2), // Adjust the spacing between the icon and text
                          Text(
                            widget.stock > 0
                                ? "Add to cart".toUpperCase()
                                : "Out of stock".toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 95,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 12, 0, 4),
                      child: Text(
                        widget.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            color: MyTheme.secondary,
                            fontSize: 14,
                            height: 1.2,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 4),
                          child: RatingBar(
                            itemSize: 18.0,
                            ignoreGestures: true,
                            initialRating:
                                double.parse(widget.ratings.toString()),
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            ratingWidget: RatingWidget(
                              full: Icon(
                                FontAwesome.star,
                                color: Color.fromRGBO(192, 53, 50, 1),
                              ),
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
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 4),
                          child: Text(
                            "(${widget.reviews})",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                color: MyTheme.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Visibility(
                          visible: widget.price != widget.sale_price,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              "৳" + widget.price,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: MyTheme.dark_grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Padding(
                          padding: widget.price != widget.sale_price
                              ? EdgeInsets.fromLTRB(20, 0, 0, 0)
                              : EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Text(
                            "৳" + widget.sale_price,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                                color: MyTheme.secondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    // widget.has_discount
                    //     ?

                    //: Container(),
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}
