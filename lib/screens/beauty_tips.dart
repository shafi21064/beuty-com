import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kirei/my_theme.dart';
import 'package:kirei/screens/common_webview_screen.dart';
import 'package:kirei/ui_sections/drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class BeautyTips extends StatefulWidget {
  BeautyTips({Key key}) : super(key: key);

  @override
  _BeautyTipsState createState() => _BeautyTipsState();
}

class _BeautyTipsState extends State<BeautyTips> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final youtube_url =
      Uri.parse("youtube://www.youtube.com/channel/@j-beautybykirei213");
  final http_url = Uri.parse("https://www.youtube.com/@j-beautybykirei213");

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: MainDrawer(),
        backgroundColor: Colors.grey[100],
        appBar: buildAppBar(context),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: MyTheme.light_grey, width: 0.4),
                borderRadius: BorderRadius.circular(16.0),
              ),
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return CommonWebviewScreen(
                          url: "https://kireibd.com/blogs?type=app",
                          page_name: "Blog",
                        );
                      }));
                },
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(10),
                              right: Radius.circular(10),
                            ),
                            child: Image.asset('assets/beauty-home-01.png',
                                fit: BoxFit.cover),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Beauty Blogs",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 26,
            ),
            Card(
              elevation: 0,
              color: Colors.transparent,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: MyTheme.light_grey, width: 0.4),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: GestureDetector(
                onTap: () {
                  _launchUrl(Uri.parse("https://www.youtube.com/@j-beautybykirei213"));
                },
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(10),
                              right: Radius.circular(10),
                            ),
                            child: Image.asset('assets/kireibd-youtube.png',
                                fit: BoxFit.cover),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Kirei Youtube",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {
          _scaffoldKey.currentState.openDrawer();
        },
        child: Builder(
          builder: (context) => Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 18.0, horizontal: 0.0),
            child: Container(
              child: Image.asset(
                'assets/hamburger.png',
                height: 16,
                color: MyTheme.dark_grey,
              ),
            ),
          ),
        ),
      ),
      title: Text(
        getAppBarTitle(),
        style: GoogleFonts.ubuntu(fontSize: 18, color: Colors.blueGrey),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  String getAppBarTitle() {
    String name = "Beauty Tips ";

    return name;
  }


  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
