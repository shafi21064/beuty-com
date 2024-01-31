import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kirei/custom/toast_component.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:kirei/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:kirei/repositories/cart_repository.dart';
import 'package:kirei/screens/cart.dart';
import 'package:kirei/screens/login.dart';
import 'package:kirei/screens/product_details.dart';
import 'package:kirei/app_config.dart';
import 'package:toast/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class MiniProductCard extends StatefulWidget {
  int id;
  //String image;
  String name;
  String price;
  String sale_price;
  dynamic ratings;
  String image;
  String slug;
  int reviews;
  int stock;

  MiniProductCard({
    Key key,
    this.id,
    this.image,
    this.name,
    this.price,
    this.sale_price,
    this.ratings,
    this.slug,
    this.reviews,
    this.stock,
  }) : super(key: key);

  @override
  _MiniProductCardState createState() => _MiniProductCardState();
}

class _MiniProductCardState extends State<MiniProductCard> {
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
        .getCartAddResponse(widget.id, _variant, user_id.$, _quantity);

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
    
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetails(id: widget.id, slug: widget.slug);
        }));
      },
      child: Card(
      
elevation: 0, // Set the elevation to 0 for no shadow
  
        child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: (MediaQuery.of(context).size.width - 36) / 3,
                child: ClipRRect(
                    child: widget.image == ''
                        ? Image.asset(
                            'assets/app_logo.png',
                            fit: BoxFit.fitWidth,
                          )
                        : FadeInImage.assetNetwork(
                            placeholder: 'assets/placeholder.png',
                            image: widget.image,
                            fit: BoxFit.fill,
                          )),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2 - .5,
                height: 36,
                child: RaisedButton(
                  onPressed: () {
                    onPressAddToCart(context);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0)),
                  padding: EdgeInsets.all(0.0),
                  child: Ink(
                 
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
              Padding(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Text(
                  widget.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      color: MyTheme.secondary,
                      fontSize: 11,
                      height: 1.2,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(8, 4, 5, 2),
                    child: RatingBar(
                      itemSize: 12.0,
                      ignoreGestures: true,
                      initialRating: double.parse(widget.ratings.toString()),
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      ratingWidget: RatingWidget(
                        full: Icon(FontAwesome.star,
                            color: Color.fromRGBO(192, 53, 50, 1)),
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
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Text(
                      "(${widget.reviews})",
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          color: MyTheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Text(
                  "৳" + widget.sale_price,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                      color: MyTheme.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Visibility(
                visible: widget.sale_price != widget.price,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Text(
                    "৳" + widget.price,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: MyTheme.dark_grey,
                        fontSize: 9,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
