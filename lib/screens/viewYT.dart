import 'package:active_ecommerce_flutter/helpers/api.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/screens/video_description_screen.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/repositories/extra_repository.dart';
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
  var token = "113|QcbzqMYo8HcDEcBfeNuCpdAKbD2ujHwmGl3hTZF3";

  List book = [
    {
      "id": 3,
      "category_id": 1,
      "title": "Mega tips",
      "slug": "dsfdf",
      "banner": "KireiYoutubes/banner_3.png",
      "video": "https://www.youtube.com/watch?v=SiZmEJmiU9M",
      "short_description": "fg",
      "description": "dfdfdf",
      "order": 0,
      "is_active": 1,
      "created_by": null,
      "updated_by": null,
      "created_at": "2022-07-20T10:10:27.000000Z",
      "updated_at": "2022-07-20T10:10:27.000000Z",
      "deleted_at": null
    }
  ];

  Future viewYT() async {
    var data = await getApi("kirei-youtube-video/${widget.slug}");
    if (data['data'] != null) {
      for (int i = 0; i < data['data'].length; i++) {
        setState(() {
          book.add(data['data'][i]);
        });
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //this.viewYT();
  }

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.short_description,
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w700,
                              fontSize: 21),
                        ),
                        Spacer(),

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
                    SizedBox(
                      height: 80,
                    ),
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
                      child: Container(
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
