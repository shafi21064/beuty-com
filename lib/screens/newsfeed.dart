import 'package:active_ecommerce_flutter/helpers/file_helper.dart';
import 'package:active_ecommerce_flutter/repositories/extra_repository.dart';
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

class FeedList extends StatefulWidget {
  FeedList({Key key}) : super(key: key);

  @override
  _FeedListState createState() => _FeedListState();
}

class _FeedListState extends State<FeedList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<bool> isMore = [];

  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _hashtagsController = TextEditingController();

  //for image uploading
  final ImagePicker _picker = ImagePicker();
  XFile _file;
  String base64Image='';
  String fileName='';

  pickCommunityImg(context) async {
    var status = await Permission.photos.request();

    if (status.isDenied) {
      // We didn't ask for permission yet.
      showDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
                title:
                    Text(AppLocalizations.of(context).common_photo_permission),
                content: Text(
                    AppLocalizations.of(context).common_app_needs_permission),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(AppLocalizations.of(context).common_deny),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  CupertinoDialogAction(
                    child: Text(AppLocalizations.of(context).common_settings),
                    onPressed: () => openAppSettings(),
                  ),
                ],
              ));
    } else if (status.isRestricted) {
      ToastComponent.showDialog(
          AppLocalizations.of(context).common_give_photo_permission, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    } else if (status.isGranted) {
      //file = await ImagePicker.pickImage(source: ImageSource.camera);
      _file = await _picker.pickImage(source: ImageSource.gallery);

      if (_file == null) {
        ToastComponent.showDialog(
            AppLocalizations.of(context).common_no_file_chosen, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      }

      //return;
       base64Image = FileHelper.getBase64FormateFile(_file.path);
    setState(() {
      fileName = _file.path.split("/").last;

    });
    }
  }

  addCommunityPost(context) async {
    if(_descriptionController.text==''){
      ToastComponent.showDialog("Write something...", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }else{
      ToastComponent.showDialog("Adding post..", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    }

      var newCommunityPostResponse =
          await ExtraRepository().getNewCommunityPostResponse(
        base64Image,
        fileName,
      //  _titleController.text.toString(),
        _descriptionController.text.toString()
       // _hashtagsController.text.toString(),
      );

      if (newCommunityPostResponse.result == false) {
        ToastComponent.showDialog(newCommunityPostResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        return;
      } else {
        _descriptionController.clear();
        ToastComponent.showDialog(newCommunityPostResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        setState(() {});
      }

  }

  Future<void> _onPageRefresh() async {}

  Future<bool> addLike(String post_id) async {
    var addLikeResponse =
        await ExtraRepository().getCommunityLikeCreateResponse(post_id);

  if (addLikeResponse.result == false) {
      ToastComponent.showDialog("Login first!", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

      setState(() {});
    }
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
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 10.0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          child: Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                child: Text(
                                  'Community post',
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.blue),
                                ),
                              ), // title: login
                              // name textfield
                              Padding(
                                padding: const EdgeInsets.only(right: 32.0),
                                child: TextFormField(
                                  controller: _descriptionController,
                                  keyboardType: TextInputType.multiline,
                                  minLines:
                                      3, //Normal textInputField will be displayed
                                  maxLines: 5, //
                                  decoration: InputDecoration(
                                      hintText: 'Share your mind on community..'),
                                  validator: (v) {
                                    if (v.trim().isEmpty) {
                                      return 'Please enter something';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                     width:50,
                                      height: 18,
                                      margin: EdgeInsets.only(right: 10),
                                      child: fileName==''?Text(''):Text(fileName,textAlign: TextAlign.end,)),
                                  FlatButton(
                                  onPressed: () async {
                        await pickCommunityImg(context);
                        },

                                    child: Icon(
                                      Icons.add_photo_alternate_outlined,
                                      color: Colors.white,
                                    ),
                                    color: Colors.blueGrey,
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  RaisedButton(
                                    onPressed: () async {
                                      await addCommunityPost(context);
                                    },

                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40.0)),
                                    padding: EdgeInsets.all(0.0),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                          gradient: FlutterGradients.denseWater(
                                            type: GradientType.linear,
                                            center: Alignment.center,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 100.0, minHeight: 36.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Add",
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.ubuntu(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 15, top: 12, bottom: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                              left: BorderSide(color: Colors.teal, width: 5)),
                        ),
                        child: Text(
                          ' HashTags',
                          style: GoogleFonts.ubuntu(
                              color: Colors.red[800], fontSize: 18),
                        ),
                      )),
                  SizedBox(
                    child: buildFeedHashList(),
                    height: 42,
                  ),
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
    String name = "Kirei Community ";

    return name;
  }

  buildFeedHashList() {
    var future = ExtraRepository().getCommunityHashTags();
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            //snapshot.hasError
            print("Community Hash list error");
            print(snapshot.error.toString());
            return Container(
              height: 10,
            );
          } else if (snapshot.hasData) {
            //snapshot.hasData
            var comHashResponse = snapshot.data;
            return Container(
              width: 150,
              height: 50,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ListView.builder(
                  itemCount: comHashResponse.data.length,
                  scrollDirection: Axis.horizontal,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    isMore.add(false);
                    print(isMore[index]);

                    return Container(
                      padding: const EdgeInsets.only(
                          top: 4.0, bottom: 4.0, left: 10.0, right: 10.0),
                      child: buildFeedHashCard(comHashResponse, index),
                    );
                  },
                ),
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

  buildFeedList() {
    var future = ExtraRepository().getCommunityPosts();
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            //snapshot.hasError
            print("Community post list error");
            print(snapshot.error.toString());
            return Container(
              height: 10,
            );
          } else if (snapshot.hasData) {
            //snapshot.hasData
            var compostResponse = snapshot.data;
            return SingleChildScrollView(
              child: ListView.builder(
                itemCount: compostResponse.data.length,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  isMore.add(false);
                  print(isMore[index]);

                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 4.0, bottom: 4.0, left: 10.0, right: 10.0),
                    child: buildFeedItemCard(compostResponse, index),
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

  buildFeedHashCard(comHashResponse, index) {
    return Container(
      constraints: const BoxConstraints(
      maxWidth: 200,
    ),    child: ElevatedButton(
        onPressed: () {},
        child: Text(comHashResponse.data[index].title,
            style: TextStyle(fontSize: 20)),
      ),
    );
  }

  Card buildFeedItemCard(compostResponse, index) {
    return Card(
      shape: RoundedRectangleBorder(
        side: new BorderSide(color: MyTheme.light_grey, width: 0.4),
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
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
                      compostResponse.data[index].customerName,
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
                      compostResponse.data[index].date,
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
            child: ReadMoreText(
              compostResponse.data[index].title == null
                  ? ''
                  : compostResponse.data[index].title + '\n' + compostResponse.data[index].description == null
                      ? ''
                      : compostResponse.data[index].description,
              trimLines: 3,
              style: TextStyle(color: Colors.black, fontSize: 15),
              colorClickableText: Colors.blueGrey,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'See more',
              trimExpandedText: '  ',
            ),
          ),
        ),
        Container(
            width: double.infinity,
            height: 210,
            child: ClipRRect(
                borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(10), right: Radius.circular(10)),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/placeholder.png',
image: (compostResponse.data[index].banner != null && compostResponse.data[index].banner.isNotEmpty)
      ? compostResponse.data[index].banner
      : 'https://picsum.photos/seed/picsum/200/300',                  fit: BoxFit.cover,
                ))),
        Container(
          height: 60,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [

              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Comments(compostResponse.data[index].id))); },
                child: Padding(
                  padding: EdgeInsets.only(left: 20, top: 23),
                  child: Text(
                    "${compostResponse.data[index].commentsCount} Comment    ",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: MyTheme.medium_grey, fontSize: 16),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(6, 8, 8, 0),
                child: LikeButton(
                  // onTap: addLike(compostResponse.data[index].id),
                  // ignore: missing_return
                  onTap: (bool isLiked) async {
                    if (1 == 1) {
                      addLike(compostResponse.data[index].id.toString());
                    } else {
                      ToastComponent.showDialog("Login first!", context,
                          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
                    }
                    return !isLiked;
                  },

                  size: 56,
                  isLiked:compostResponse.data[index].isLike ==true
                      ? true
                      : false,
                  circleColor: CircleColor(
                      start: Color(0xff00ddff), end: Color(0xff0099cc)),
                  bubblesColor: BubblesColor(
                    dotPrimaryColor: Color(0xff33b5e5),
                    dotSecondaryColor: Color(0xff0099cc),
                  ),
                  likeBuilder: (bool isLiked) {
                    return Icon(
                      Icons.favorite,
                      color: isLiked ? Colors.deepPurpleAccent : Colors.grey,
                      size: 31,
                    );
                  },
                  likeCount: compostResponse.data[index].likeCount,
                  countPostion: CountPostion.right,
                  likeCountPadding: EdgeInsets.all(0),
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  countBuilder: (int count, bool isLiked, String text) {
                    var color = isLiked ? Colors.deepPurpleAccent : Colors.grey;
                    Widget result;
                    if (count == 0) {
                      result = Text(
                        "love",
                        style: TextStyle(color: color),
                      );
                    } else
                      result = Text(
                        text,
                        style: TextStyle(color: color, fontSize: 18),
                      );
                    return result;
                  },
                ),
              ),




            ],
          ),
        ),
      ]),
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
