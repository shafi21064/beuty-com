import 'package:kirei/helpers/api.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/material.dart';

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

