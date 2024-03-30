import 'package:kirei/custom/toast_component.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:kirei/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:kirei/providers/cart_count_update.dart';
import 'package:kirei/repositories/cart_repository.dart';
import 'package:kirei/screens/cart.dart';
import 'package:kirei/screens/login.dart';
import 'package:kirei/screens/product_details.dart';
import 'package:kirei/app_config.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
  int discount;
  int preorderAvailable;
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
      this.stock,
      this.preorderAvailable,
        this.discount
      //this.has_discount
      })
      : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
   int _quantity = 1;
  String _variant="";

  onPressAddToCart(context) {
    addToCart(mode: "add_to_cart", context: context);
  }
    addToCart({mode, context = null, snackbar = null}) async {
    if (is_logged_in.$ == false) {
      // ToastComponent.showDialog(AppLocalizations.of(context).common_login_warning, context,
      //     gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      return;
    }

    // print(widget.id);
    // print(_variant);
    // print(user_id.$);
    //print(_quantity);
    print(access_token.$);
    var cartAddResponse = await CartRepository()
        .getCartAddResponse(widget.id, _variant, user_id.$, _quantity,widget.preorderAvailable);

    if (cartAddResponse.result == false) {
      ToastComponent.showDialog(cartAddResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    } else {
      if (mode == "add_to_cart") {
        // if (snackbar != null && context != null) {
        //   Scaffold.of(context).showSnackBar(snackbar);
        // }
        ToastComponent.showDialog(cartAddResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
       
      } 
    }
  }
  @override
  Widget build(BuildContext context) {

    var addCartProduct = Provider.of<CartCountUpdate>(context, listen: true);

    print((MediaQuery.of(context).size.width - 48) / 2);
    var discountPercentage = ((((int.parse(widget.price) - int.parse(widget.sale_price))/(int.parse(widget.price)))*100 ).toStringAsFixed(0).toString());
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetails(
            id: widget.id,
            slug: widget.slug,
            discount: widget.discount,
            price:widget.price,
            sale_price: widget.sale_price,
            stock: widget.stock,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  //width: double.infinity,
                  //width: MediaQuery.of(context).size.width / 2 - .5,
                  padding: EdgeInsets.only(bottom: 8),
                  //height: 158,
                  height: ((MediaQuery.of(context).size.width - 32) / 2.5),
                  child: Stack(
                    children: [
                      Center(
                        child: ClipRRect(
                            clipBehavior: Clip.antiAlias,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(0), bottom: Radius.zero),
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                color: MyTheme.light_grey,
                                child: widget.image != null
                                    ? FadeInImage.assetNetwork(
                                        placeholder: 'assets/placeholder.png',
                                        image: widget.image,
                                        //fit: BoxFit.fill,
                                        fit: BoxFit.fitWidth
                                      )
                                    : Image.asset(
                                        'assets/placeholder.png',
                                        fit: BoxFit.fitWidth,
                                      ))),
                      ),
                      Visibility(
                        visible: widget.sale_price != widget.price,
                        child: Positioned(
                          left: 5,
                          top: 5,
                          child: Container(
                            height: 33,
                            width: 33,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: MyTheme.primary,
                                shape: BoxShape.circle
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Text('-${widget.discount}%',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: MyTheme.white,
                                    fontSize: 10
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              Container(
                width: MediaQuery.of(context).size.width / 2 - .5,
                //width: MediaQuery.of(context).size.width * 0.35,
                height: 40,
                child: RaisedButton(
                  onPressed: () {
                     onPressAddToCart(context);
                     if(is_logged_in.$ != false){

                      if( widget.preorderAvailable == 1){
                        addCartProduct.getReset();
                        addCartProduct.getIncrease();
                      } else if(widget.stock>0){
                        addCartProduct.getIncrease();
                      }

                    }
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
                      color:
                      widget.preorderAvailable == 1
                          ? Color.fromRGBO(23, 162, 190, 1)
                          :
                       (widget.stock > 0
                          ? MyTheme.add_to_cart_button
                          : Color.fromRGBO(192, 53, 50, 1)),
                      constraints:
                          BoxConstraints(maxWidth: 300.0, minHeight: 30.0),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: widget.stock > 0 || widget.preorderAvailable == 1,
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
  widget.preorderAvailable == 1
    ? "Preorder Now".toUpperCase()
    : (widget.stock > 0 
      ? "Add to Cart".toUpperCase()
      : "Out of Stock".toUpperCase()),
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
                //width: MediaQuery.of(context).size.width * 0.35,
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
