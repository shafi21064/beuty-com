import 'package:kirei/helpers/api.dart';
import 'package:kirei/helpers/file_helper.dart';
import 'package:kirei/repositories/extra_repository.dart';
import 'package:kirei/repositories/viewBB.dart';
import 'package:kirei/screens/viewYT.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kirei/my_theme.dart';
import 'package:kirei/ui_sections/drawer.dart';
import 'package:kirei/custom/toast_component.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:like_button/like_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:readmore/readmore.dart';
import 'package:toast/toast.dart';
import 'package:kirei/screens/category_products.dart';
import 'package:kirei/repositories/category_repository.dart';
import 'package:shimmer/shimmer.dart';
import 'package:kirei/app_config.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'comments.dart';

class kireiYT extends StatefulWidget {
  kireiYT({Key key}) : super(key: key);

  @override
  _kireiYTState createState() => _kireiYTState();
}

class _kireiYTState extends State<kireiYT> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<bool> isMore = [];

  Future<void> _onPageRefresh() async {}

  List youtubes = [];
  Future viewYTS() async {
    var data = await getApi("youtube-videos");
    if (data['data'] != null) {
      for (int i = 0; i < data['data'].length; i++) {
        setState(() {
          youtubes.add(data['data'][i]);
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.viewYTS();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
          key: _scaffoldKey,
          drawer: MainDrawer(),
          backgroundColor: Colors.grey[100],
          appBar: buildAppBar(context),
          body: Stack(children: [
            CustomScrollView(
              slivers: [
                SliverList(
                    delegate: SliverChildListDelegate([
                  SizedBox(
                    //height: 400,
                    child: ListView.builder(
                      itemCount: youtubes.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        isMore.add(false);
                        print(isMore[index]);

                        return Container(
                          padding: const EdgeInsets.only(
                              top: 4.0, bottom: 4.0, left: 10.0, right: 10.0),
                          child: Container(
                            width: 300,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ViewYT(
                                    youtubes[index]['id'],
                                    youtubes[index]['title'],
                                    youtubes[index]['slug'],
                                    youtubes[index]['banner'],
                                    youtubes[index]['video'],
                                    youtubes[index]['short_description'],
                                    youtubes[index]['description'],
                                  );
                                }));
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  side: new BorderSide(
                                      color: MyTheme.light_grey, width: 0.4),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                elevation: 0,
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        // height: 170,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 300,
                                                  margin:
                                                      const EdgeInsets.all(20),
                                                  child: Text(
                                                    youtubes[index]['title'],
                                                    style: GoogleFonts.ubuntu(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                          width: double.infinity,
                                          height: 210,
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.horizontal(
                                                      left: Radius.circular(10),
                                                      right:
                                                          Radius.circular(10)),
                                              child: youtubes[index]['banner']
                                                      .contains('http')
                                                  ? Image.network(
                                                      youtubes[index]['banner'],
                                                    )
                                                  : Image.asset(
                                                      "assets/ytt.webp",
                                                      fit: BoxFit.cover,
                                                    ))),
                                    ]),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ]))
              ],
            ),
          ])),
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
    String name = "Kirei Youtube";

    return name;
  }

  Container buildBottomContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),

      height: 80,
      //color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                width: (MediaQuery.of(context).size.width - 32),
                height: 40,
                child: FlatButton(
                  minWidth: MediaQuery.of(context).size.width,
                  //height: 50,
                  color: MyTheme.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0))),
                  child: Text(
                    AppLocalizations.of(context)
                            .category_list_screen_all_products_of +
                        " ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {},
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
