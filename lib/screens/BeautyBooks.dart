import 'package:kirei/helpers/file_helper.dart';
import 'package:kirei/repositories/extra_repository.dart';
import 'package:kirei/screens/blog_view.dart';
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

class BeautyBooks extends StatefulWidget {
  BeautyBooks({Key key}) : super(key: key);

  @override
  _BeautyBooksState createState() => _BeautyBooksState();
}

class _BeautyBooksState extends State<BeautyBooks> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<bool> isMore = [];

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

                      buildFeedList(),
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
    String name = "Beauty Blogs ";

    return name;
  }


  buildFeedList() {
    var future = ExtraRepository().getBeautyBlogPosts();
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            //snapshot.hasError
            print("Beauty Blogs list error");
            print("SNAPSHOT: $snapshot");
            //print(snapshot.error.toString());
            return Container(
              height: 10,
            );
          } else if (snapshot.hasData) {
            //snapshot.hasData
            var compostResponse = snapshot.data;
            return SingleChildScrollView(
              child: ListView.builder(
                itemCount: compostResponse.data.recentPosts.length,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  isMore.add(false);
                  print(isMore[index]);

                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 4.0, bottom: 4.0, left: 10.0, right: 10.0),
                    child: buildFeedItemCard(compostResponse.data.recentPosts, index),
                  );
                },
              ),
            );
          } else {
            return SingleChildScrollView(
              child: ListView.builder(
                itemCount: 3,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 4.0, bottom: 4.0, left: 16.0, right: 16.0),
                    child: Row(
                      children: [
                        Shimmer.fromColors(
                          baseColor: MyTheme.shimmer_base,
                          highlightColor: MyTheme.shimmer_highlighted,
                          child: Container(
                            height: 60,
                            width: 60,
                            color: Colors.white,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0, bottom: 8.0),
                              child: Shimmer.fromColors(
                                baseColor: MyTheme.shimmer_base,
                                highlightColor: MyTheme.shimmer_highlighted,
                                child: Container(
                                  height: 20,
                                  width: MediaQuery.of(context).size.width * .7,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Shimmer.fromColors(
                                baseColor: MyTheme.shimmer_base,
                                highlightColor: MyTheme.shimmer_highlighted,
                                child: Container(
                                  height: 20,
                                  width: MediaQuery.of(context).size.width * .5,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
        });
  }


  Card buildFeedItemCard(compostResponse, index) {
    return Card(
      shape: RoundedRectangleBorder(
        side: new BorderSide(color: MyTheme.light_grey, width: 0.4),
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0,
      child:
      InkWell(onTap: (){
        Navigator.push(context,
            MaterialPageRoute(
                builder: (context) {
                  return ViewBlog(
                    author: compostResponse[index].author,
                    date: compostResponse[index].date.toString(),
                    title: compostResponse[index].title,
                    content: compostResponse[index].content,
                    picture: compostResponse[index].picture[0].url,
                  );
                }));



      },
        child: Column(mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 70,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        height: 58,
                        width: 54,
                        margin: const EdgeInsets.only(
                            left: 5.0, right: 0, top: 5, bottom: 0),
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(140)),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://i.insider.com/5c9a115d8e436a63e42c2883?width=600&format=jpeg&auto=webp',
                          ),
                        )),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, top: 15),
                          child: Text(
                            compostResponse[index].author,
                            style: GoogleFonts.lato(
                                color: Colors.grey[700],
                                fontSize: 16,
                                letterSpacing: 1,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, top: 2),
                          child: Text(
                            compostResponse[index].date.toString(),
                            style: GoogleFonts.ubuntu(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, bottom: 10, right: 10),
                child:
                //text widget to display long text
                InkWell(
                  onTap: () {
                    setState(() {
                      // toggle the bool variable true or false
                      isMore[index] = !isMore[index];
                    });
                  },
                  child: Text(
                    compostResponse[index].title,

                  ),
                ),
              ),
              Container(
                  width: double.infinity,
                  height: 210,
                  child: ClipRRect(
                      borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(10), right: Radius.circular(10)),
                      child: compostResponse[index].picture.length == 0
  ? Image.asset('assets/no_pic.png',fit:BoxFit.cover)
  : compostResponse[index].picture[0].url == null
    ? Image.asset('assets/no_pic.png',fit:BoxFit.cover,):

                      FadeInImage.assetNetwork(
                        placeholder: 'assets/placeholder.png',
                        image: compostResponse[index].picture[0].url,
                        fit: BoxFit.cover,
                      ))),

            ]),
      ),
    );
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
                  color: MyTheme.accent_color,
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
