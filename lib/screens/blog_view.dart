import 'package:kirei/helpers/api.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:kirei/custom/toast_component.dart';
import 'package:kirei/repositories/extra_repository.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../app_config.dart';

class ViewBlog extends StatefulWidget {
  String author;
  String date;
  String title;
  String content;
  String picture;
  ViewBlog({
    this.author,
    this.date,
    this.title,
    this.content,
    this.picture,
  });

  @override
  _ViewBlogState createState() => _ViewBlogState();
}

class _ViewBlogState extends State<ViewBlog> {

  List blog = [];
  Future viewBlog() async {
    var data = await getApi("blogs/${''}");
    if (data['data'] != null) {
      for (int i = 0; i < data['data'].length; i++) {
        setState(() {
          blog.add(data['data'][i]);
        });
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //this.viewBook();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Blog Details"),
        backgroundColor: Colors.pink,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                widget.picture==null
                    ? Image.asset(
                        'assets/no_pic.png',
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        widget.picture,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fitWidth,
                      ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              widget.title,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 21),
                            ),
                          ),

                        ],
                      ),


                      SizedBox(
                        height: 10,
                      ),
                      Html(
    data: """
    ${widget.content}
    """,
                      ),
                      SizedBox(
                        height: 80,
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
      ),
    );
  }
}

/*


import 'package:kirei/custom/toast_component.dart';
import 'package:kirei/repositories/extra_repository.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class CommunityComment extends StatefulWidget {
  int id;
  CommunityComment({Key key,this.id}) : super(key: key);

  @override
  _CommunityCommentState createState() => _CommunityCommentState();
}

class _CommunityCommentState extends State<CommunityComment> {
  TextEditingController _commentController = TextEditingController();


  addComment() async {
    var comment = _commentController.text.toString();

    if (comment == "") {
      ToastComponent.showDialog("Empty comment!", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    var addCommentResponse =
    await ExtraRepository().getCommunityCommentCreateResponse(
        comment,
        widget.id
    );

    if (addCommentResponse.success == false) {
      ToastComponent.showDialog("Comment Successfully.", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    } else {
      ToastComponent.showDialog("Comment failed!", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

      setState(() {});
    }
  }



  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

*/
