import 'package:kirei/helpers/api.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:http/http.dart' as http;
import 'package:kirei/custom/toast_component.dart';
import 'package:kirei/repositories/extra_repository.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../app_config.dart';

class Comments extends StatefulWidget {
  int id;
  Comments(this.id);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  TextEditingController _commentController = TextEditingController();

  List comments = [];
  Future viewComments() async {
    var data = await getApi("community-comments/${widget.id}");
    if (data['data'] != null) {
      for (int i = 0; i < data['data'].length; i++) {
        setState(() {
          comments.add(data['data'][i]);
        });
      }
      setState(() {});
    }
  }

  addComment() async {
    var comment = commentController.text.toString();

    if (comment == "") {
      ToastComponent.showDialog("Empty comment!", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    }

    var addCommentResponse = await ExtraRepository()
        .getCommunityCommentCreateResponse(comment, widget.id);

    if (addCommentResponse.success == false) {
      ToastComponent.showDialog("Comment Faild.", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    }
      setState(() {});

  }

  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.viewComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comment Page"),
        backgroundColor: Colors.pink,
      ),
      body: Container(
        child: CommentBox(
          userImage:avatar_original.$,
          child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
                  child: ListTile(
                    leading: GestureDetector(
                      onTap: () async {
                        // Display the image in large form.
                        print("Comment Clicked");
                      },
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: new BoxDecoration(
                            color: Colors.blue,
                            borderRadius:
                                new BorderRadius.all(Radius.circular(50))),
                        child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                                comments[i]['customer_avatar'] == null
                                    ? ''
                                    : comments[i]['customer_avatar'])),
                      ),
                    ),
                    title: Text(
                      comments[i]['customer_name']==null?'NULL':comments[i]['customer_name'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(comments[i]['comment']),
                  ),
                );
              }),
          labelText: 'Write a comment...',
          withBorder: false,
          errorText: 'Comment cannot be blank',
          sendButtonMethod: () {
            if (formKey.currentState.validate()) {
              print(commentController.text);
              setState(() {
                var value = {
                  "comment": commentController.text,
                  "customer_name": user_name.$,
                  "customer_avatar": avatar_original.$
                };
                addComment();
                comments.insert(0, value);
              });
              commentController.clear();
              FocusScope.of(context).unfocus();
            } else {
              print("Not validated");
            }
          },
          formKey: formKey,
          commentController: commentController,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          sendWidget: Icon(Icons.send_sharp, size: 30, color: Colors.white),
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
