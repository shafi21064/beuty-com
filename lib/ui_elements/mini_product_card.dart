import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/screens/product_details.dart';
import 'package:active_ecommerce_flutter/app_config.dart';

class MiniProductCard extends StatefulWidget {
  int id;
  //String image;
  String name;
  String price;
  String sale_price;
  dynamic ratings;
  String image;
  String slug;

  MiniProductCard({
    Key key,
    this.id,
    this.image,
    this.name,
    this.price,
    this.sale_price,
    this.ratings,
    this.slug,
  }) : super(key: key);

  @override
  _MiniProductCardState createState() => _MiniProductCardState();
}

class _MiniProductCardState extends State<MiniProductCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProductDetails(id: widget.id, slug: widget.slug);
        }));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0.0,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: (MediaQuery.of(context).size.width - 36) / 3.5,
                child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16), bottom: Radius.zero),
                    child: widget.image == ''
                        ? Image.asset(
                            'assets/app_logo.png',
                            fit: BoxFit.fitWidth,
                          )
                        : FadeInImage.assetNetwork(
                            placeholder: 'assets/placeholder.png',
                            image: widget.image,
                            fit: BoxFit.cover,
                          )),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 4, 8, 0),
                child: Text(
                  widget.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                      color: MyTheme.font_grey,
                      fontSize: 11,
                      height: 1.2,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Text(
                  "৳" + widget.sale_price,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                      color: MyTheme.accent_color,
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
                        color: MyTheme.medium_grey,
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
