import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kirei/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:kirei/screens/product_details.dart';
import 'package:kirei/app_config.dart';

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
        // shape: RoundedRectangleBorder(
        //   side: new BorderSide(color: MyTheme.light_grey, width: 1.0),
        //   borderRadius: BorderRadius.circular(16.0),
        // ),
        // elevation: 0.0,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: (MediaQuery.of(context).size.width - 36) / 3.5,
                child: ClipRRect(
                    child: widget.image == ''
                        ? Image.asset(
                            'assets/app_logo.png',
                            fit: BoxFit.fitWidth,
                          )
                        : FadeInImage.assetNetwork(
                            placeholder: 'assets/placeholder.png',
                            image: widget.image,
                            fit: BoxFit.fitWidth,
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
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Text(
                      "(${widget.reviews})",
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          color: MyTheme.accent_color,
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
