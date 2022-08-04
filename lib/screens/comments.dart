
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CommentModal extends StatefulWidget {
  final ScrollController scrollController;
  final bool reverse;

  const CommentModal({Key key, this.scrollController, this.reverse = false})
      : super(key: key);

  @override
  _CommentModalState createState() => _CommentModalState();
}

class _CommentModalState extends State<CommentModal> {

  @override
  Widget build(BuildContext context) {

    return Material(
        child: CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
              backgroundColor: Color(0xFFC72C41),
              leading: Container(),
              middle: Text('Comments',)),
          child: SafeArea(
            bottom: false,
            child: Scaffold(
              body: Container(
                color: Colors.redAccent,
                child: Column(
                  children: <Widget>[

                    Text('ddmmm',style: TextStyle(color: Colors.redAccent),)

                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget get _topBar => Center(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(10, 2, 10, 30),
      child: Text(
        'UIHelper.signInLower',
        style: TextStyle(
          color: Colors.redAccent,
          fontSize: 47,
          fontWeight: FontWeight.w200,
        ),
      ),
    ),
  );

  Widget get _bottomBar => Expanded(
    child: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(60), topRight: Radius.circular(60))),
      child: Padding(
        padding: const EdgeInsets.all(34.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                'UIHelper.hello',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1),
              ),

            ],
          ),
        ),
      ),
    ),
  );


}

