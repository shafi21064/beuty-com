import 'package:active_ecommerce_flutter/helpers/api.dart';
import 'package:active_ecommerce_flutter/helpers/file_helper.dart';
import 'package:active_ecommerce_flutter/repositories/extra_repository.dart';
import 'package:active_ecommerce_flutter/repositories/viewBB.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/ui_sections/drawer.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:like_button/like_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:readmore/readmore.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/screens/category_products.dart';
import 'package:active_ecommerce_flutter/repositories/category_repository.dart';
import 'package:shimmer/shimmer.dart';
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
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

  Future<void> _onPageRefresh() async {}

  List books = [];
  Future viewBooks() async {
    var data = await getApi("beauty-books");
    if (data != null) {
      for (int i = 0; i < data.length; i++) {
        setState(() {
          books.add(data[i]);
        });
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.viewBooks();
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
                    child: ListView.builder(
                      itemCount: books.length,
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        isMore.add(false);
                        print(isMore[index]);

                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 4.0, bottom: 4.0, left: 10.0, right: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(
                                      left: 15, top: 12, bottom: 12),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                              color: Colors.teal, width: 5)),
                                    ),
                                    child: Text(
                                      books[index]['name'],
                                      style: GoogleFonts.ubuntu(
                                          color: Colors.red[800], fontSize: 18),
                                    ),
                                  )),
                              ConstrainedBox(
                                constraints: BoxConstraints(maxHeight: 300),
                                child: ListView.builder(
                                  itemCount:
                                      books[index]['books']['data'].length,
                                  scrollDirection: Axis.horizontal,
                                  // physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, ind) {
                                    isMore.add(false);
                                    print(isMore[ind]);

                                    return Container(
                                      padding: const EdgeInsets.only(
                                          top: 4.0,
                                          bottom: 4.0,
                                          left: 10.0,
                                          right: 10.0),
                                      child: Container(
                                        width: 300,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return ViewBook(books[index]
                                                  ['books']['data'][ind]['id']);
                                            }));
                                          },
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              side: new BorderSide(
                                                  color: MyTheme.light_grey,
                                                  width: 0.4),
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                            ),
                                            elevation: 0,
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    // height: 170,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                            height: 58,
                                                            width: 54,
                                                            margin: const EdgeInsets
                                                                    .only(
                                                                left: 5.0,
                                                                right: 0,
                                                                top: 5,
                                                                bottom: 0),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(0),
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .white,
                                                                    width: 2),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            140)),
                                                            child: CircleAvatar(
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                'https://i.insider.com/5c9a115d8e436a63e42c2883?width=600&format=jpeg&auto=webp',
                                                              ),
                                                            )),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 5.0,
                                                                      top: 15),
                                                              child: Text(
                                                                books[index][
                                                                            'books']
                                                                        ['data']
                                                                    [
                                                                    ind]['title'],
                                                                style: GoogleFonts.lato(
                                                                    color: Colors
                                                                            .grey[
                                                                        700],
                                                                    fontSize:
                                                                        16,
                                                                    letterSpacing:
                                                                        1,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 5.0,
                                                                      top: 2),
                                                              child: Text(
                                                                books[index]['books']
                                                                            [
                                                                            'data']
                                                                        [ind][
                                                                    'short_description'],
                                                                style:
                                                                    GoogleFonts
                                                                        .ubuntu(
                                                                  color: Colors
                                                                          .grey[
                                                                      700],
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
                                                                  left: Radius
                                                                      .circular(
                                                                          10),
                                                                  right: Radius
                                                                      .circular(
                                                                          10)),
                                                          child: FadeInImage
                                                              .assetNetwork(
                                                            placeholder:
                                                                'assets/placeholder.png',
                                                            image:
                                                                'https://picsum.photos/seed/picsum/200/300',
                                                            fit: BoxFit.cover,
                                                          ))),
                                                ]),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
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
    String name = "Beauty Books";

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
