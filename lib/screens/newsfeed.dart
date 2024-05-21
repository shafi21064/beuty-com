import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kirei/custom/toast_component.dart';
import 'package:kirei/data_model/extra_community_response.dart';
import 'package:kirei/helpers/file_helper.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:kirei/my_theme.dart';
import 'package:kirei/repositories/extra_repository.dart';
import 'package:kirei/screens/login.dart';
import 'package:kirei/ui_sections/drawer.dart';
import 'package:like_button/like_button.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toast/toast.dart';

import 'comments.dart';

class FeedList extends StatefulWidget {
  FeedList({Key key}) : super(key: key);

  @override
  _FeedListState createState() => _FeedListState();
}

class _FeedListState extends State<FeedList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<bool> isMore = [];
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _hashtagsController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File _file;
  String fileName = '';

  Future<File> pickCommunityImg(BuildContext context) async {
    var status = await Permission.photos.request();

    if (status.isDenied) {
      showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text('Photo Permission'),
          content: Text('The app needs permission to access your photos.'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Deny'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            CupertinoDialogAction(
              child: Text('Settings'),
              onPressed: () => openAppSettings(),
            ),
          ],
        ),
      );
      return null;
    } else if (status.isRestricted) {
      showToast(context, 'Permission is restricted');
      return null;
    } else if (status.isGranted) {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) {
        showToast(context, 'No file chosen');
        return null;
      }

      setState(() {
        _file = File(pickedFile.path);
        fileName = _file.path.split("/").last;
      });

      return _file;
    }

    return null;
  }

  Future<void> addCommunityPost(BuildContext context) async {
    if (_descriptionController.text.isEmpty) {
      showToast(context, "Write something...");
      return;
    }

    showToast(context, "Adding post...");

    if (_file == null) {
      showToast(context, "No image selected...");
      return;
    }

    try {
      var response = await ExtraRepository().getNewCommunityPostResponse(
        _file,
        fileName ?? '',
        _descriptionController.text.toString(),
      );

      if (!response.result) {
        showToast(context, response.message);
        return;
      }

      _descriptionController.clear();
      showToast(context, response.message);
      setState(() {});
    } catch (e) {
      showToast(context, "An error occurred: $e");
    }
  }

  void showToast(BuildContext context, String message) {
    ToastComponent.showDialog(message, context, gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
  }

  Future<void> _onPageRefresh() async {}

  Future<bool> addLike(String post_id) async {
    var addLikeResponse = await ExtraRepository().getCommunityLikeCreateResponse(post_id);

    if (!addLikeResponse.result) {
      ToastComponent.showDialog("Login first!", context, gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      setState(() {});
    }
    return addLikeResponse.result;
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
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                                  buildCommunityPostHeader(),
                                  buildDescriptionField(),
                                  SizedBox(height: 20),
                                  buildImageUploadRow(context),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      buildFeedList(),
                    ],
                  ),
                ),
              ],
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
            padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 0.0),
            child: Image.asset(
              'assets/hamburger.png',
              height: 16,
              color: MyTheme.dark_grey,
            ),
          ),
        ),
      ),
      title: Text(
        'Kirei Community',
        style: GoogleFonts.ubuntu(fontSize: 18, color: Colors.blueGrey),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  Widget buildCommunityPostHeader() {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      child: Text(
        'Community post',
        style: TextStyle(fontSize: 18.0, color: Colors.blue),
      ),
    );
  }

  Widget buildDescriptionField() {
    return Padding(
      padding: const EdgeInsets.only(right: 32.0),
      child: TextFormField(
        controller: _descriptionController,
        keyboardType: TextInputType.multiline,
        onChanged: (value) {
          if (!is_logged_in.$) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login()));
          }
        },
        onFieldSubmitted: (value) {
          if (!is_logged_in.$) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login()));
          }
        },
        minLines: 3,
        maxLines: 5,
        decoration: InputDecoration(hintText: 'Share your mind on community..'),
        validator: (v) {
          if (v.trim().isEmpty) {
            return 'Please enter something';
          }
          return null;
        },
      ),
    );
  }

  Widget buildImageUploadRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 50,
          height: 18,
          margin: EdgeInsets.only(right: 10),
          child: fileName.isEmpty ? Text('') : Text(fileName, textAlign: TextAlign.end),
        ),
        FlatButton(
          onPressed: () async {
            if (is_logged_in.$) {
              await pickCommunityImg(context);
            } else {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login()));
            }
          },
          child: Icon(Icons.add_photo_alternate_outlined, color: Colors.white),
          color: Colors.blueGrey,
        ),
        SizedBox(width: 20),
        RaisedButton(
          onPressed: () async {
            if (is_logged_in.$) {
              await addCommunityPost(context);
            } else {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login()));
            }
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
          padding: EdgeInsets.all(0.0),
          child: Ink(
            decoration: BoxDecoration(
              gradient: FlutterGradients.denseWater(type: GradientType.linear, center: Alignment.center),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              constraints: BoxConstraints(maxWidth: 100.0, minHeight: 36.0),
              alignment: Alignment.center,
              child: Text(
                "Add",
                textAlign: TextAlign.center,
                style: GoogleFonts.ubuntu(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildFeedList() {
   // var future = ExtraRepository().getCommunityPosts();
    return FutureBuilder(
      future: ExtraRepository().getCommunityPosts(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Container(height: 10);
        } else if (snapshot.hasData) {
          print('this is your data ${snapshot.data}');
          var compostResponse = snapshot.data.data;
          return SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                physics: ScrollPhysics(),
                 itemCount: snapshot.data.data.length,
                //itemCount: 5,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                   print(snapshot.data.data.length);

                  var post = compostResponse[index];
                  var id = post.id;
                  var userName = post.customerName;
                   var userPic = post.banner;
                   var createdAt = post.date;
                  var postBody = post.description;
                  var postImg = post.banner;
                  var likeCount = post.likeCount;
                  var commentCount = post.commentsCount;
                  var isLike = post.isLike;

                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    elevation: 2.0,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                         buildPostHeader(context, userName, userPic, createdAt),
                          buildPostBody(postBody, postImg),
                          buildPostFooter(id, likeCount, commentCount, isLike),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        } else {
          return Padding(
            padding: EdgeInsets.only(top: 60.0),
            child: buildShimmerLoadingList(),
          );
        }
      },
    );
  }

  Widget buildPostHeader(BuildContext context, String userName, String userPic, String createdAt) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      leading: CircleAvatar(
        radius: 30.0,
        backgroundImage: AssetImage('assets/avater.png'),
      ),
      title: Text(
        userName ?? 'User',
        style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold, fontSize: 15, color: MyTheme.dark_grey),
      ),
      subtitle: Text(
        createdAt ?? 'Date',
        style: GoogleFonts.ubuntu(color: Colors.grey, fontSize: 13),
      ),
    );
  }

  Widget buildPostBody( postBody,  postImg) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (postBody != null && postBody.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: ReadMoreText(
              postBody,
              style: GoogleFonts.ubuntu(fontSize: 14),
              trimLines: 2,
              colorClickableText: Colors.blue,
              trimMode: TrimMode.Line,
              trimCollapsedText: '...Read more',
              trimExpandedText: ' less',
            ),
          ),
        if (postImg != null && postImg.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 10),
            child: Container(
              height: 150,
              width: double.infinity,
              child: Image.network(postImg, fit: BoxFit.fitHeight),
            ),
          ),
      ],
    );
  }

  Widget buildPostFooter( id,  likeCount,  commentCount, isLike) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildCommentButton(commentCount, id),
          buildLikeButton(id, likeCount, isLike),
        ],
      ),
    );
  }

  Widget buildLikeButton( id,  likeCount, isLike) {
    return Padding(
      padding: EdgeInsets.fromLTRB(6, 8, 8, 0),
      child: LikeButton(
        onTap: (bool isLiked) async {
          if (1 == 1) {
            addLike(id.toString());
          } else {
            ToastComponent.showDialog("Login first!", context,
                gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
          }
          return !isLiked;
        },

        size: 56,
        isLiked:
        isLike == true ? true : false,
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
        likeCount: likeCount,
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
    );
  }

  Widget buildCommentButton( commentCount, id) {
    return InkWell(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Comments(id)));
      },
        child: Text(commentCount != null ? '${commentCount.toString()} Comment' : '0'));
  }

  Widget buildShimmerLoadingList() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      child: Column(
        children: [
          for (int i = 0; i < 6; i++) buildShimmerLoadingCard(),
        ],
      ),
    );
  }

  Widget buildShimmerLoadingCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        height: 80,
        color: Colors.white,
      ),
    );
  }
}
