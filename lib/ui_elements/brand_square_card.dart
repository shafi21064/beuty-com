import 'package:kirei/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:kirei/app_config.dart';
import 'package:kirei/screens/brand_products.dart';

class BrandSquareCard extends StatefulWidget {
  int id;
  String image;
  String name;

  BrandSquareCard({Key key, this.id, this.image, this.name}) : super(key: key);

  @override
  _BrandSquareCardState createState() => _BrandSquareCardState();
}

class _BrandSquareCardState extends State<BrandSquareCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return BrandProducts(
            id: widget.id,
            brand_name: widget.name,
          );
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                  width: double.infinity,
                  height: ((MediaQuery.of(context).size.width - 24) / 2) * .45,
                  child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16), bottom: Radius.zero),
                      child: widget.image == ''
                          ? FadeInImage.assetNetwork(
                              placeholder: 'assets/placeholder.png',
                              image: widget.image,
                              fit: BoxFit.scaleDown,
                            )
                          : Image.asset(
                              'assets/app_logo.png',
                              fit: BoxFit.fitWidth,
                            ))),
              Container(
                height: 40,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text(
                    widget.name,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                        color: MyTheme.secondary,
                        fontSize: 14,
                        height: 1.6,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
