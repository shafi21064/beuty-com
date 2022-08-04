import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/repositories/extra_repository.dart';
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
