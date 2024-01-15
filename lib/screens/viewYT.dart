import 'package:kirei/helpers/api.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:kirei/screens/video_description_screen.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:kirei/custom/toast_component.dart';
import 'package:kirei/repositories/extra_repository.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../app_config.dart';
import '../my_theme.dart';

class ViewYT extends StatefulWidget {
  int id;
  String title;
  String slug;
  String banner;
  String video;
  String short_description;
  String description;
  ViewYT(this.id, this.title, this.slug, this.banner, this.video,
      this.short_description, this.description);

  @override
  _ViewYTState createState() => _ViewYTState();
}

class _ViewYTState extends State<ViewYT> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.pink,
      ),
      body: Container(
        child: Container(
          child: Column(mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    InkWell(
                      onTap: () {
                        if (widget.video == "") {
                          ToastComponent.showDialog(
                              AppLocalizations.of(context)
                                  .product_details_screen_video_not_available,
                              context,
                              gravity: Toast.CENTER,
                              duration: Toast.LENGTH_LONG);
                          return;
                        }

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return VideoDescription(
                            url: widget.video,
                          );
                        }));
                      },
                      child: Column(
                        children: [

                          Container(
                              width: double.infinity,
                              height: 210,
                              child: ClipRRect(
                                  borderRadius:
                                  BorderRadius.horizontal(
                                      left: Radius
                                          .circular(
                                          10),
                                      right: Radius
                                          .circular(
                                          10)),
                                  child:widget.banner.contains('http')?Image.network(widget.banner):
                                  Image.asset("assets/ytt.webp",fit: BoxFit.cover,)


                              )),


                          Container(
                            color: Theme.of(context).colorScheme.secondary,
                            height: 40,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                16.0,
                                0.0,
                                8.0,
                                0.0,
                              ),
                              child: Row(
                                children: [
                                  Text("Play video",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Ionicons.logo_youtube,
                                    color: MyTheme.font_grey,
                                    size: 24,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          width:320,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.short_description,
                              style:
                              GoogleFonts.abel(
                                color: Colors
                                    .grey[
                                700],
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      widget.description,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        letterSpacing: 0.6,
                        wordSpacing: 0.6,
                      ),
                    ),

                    /*Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(12)
                            ),
                            child: Text("Read Book", style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600
                            ),),
                          ),
                        ),
                        SizedBox(width: 20,),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.red,width: 2
                                ),
                                borderRadius: BorderRadius.circular(12)
                            ),
                            child: Text("More info", style: TextStyle(
                                color: Colors.teal,
                                fontSize: 18,
                                fontWeight: FontWeight.w600
                            ),),
                          ),
                        )
                      ],
                    )*/
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
