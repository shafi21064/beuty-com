import 'package:kirei/helpers/api.dart';
import 'package:flutter/material.dart';

class ViewBook extends StatefulWidget {
  int id;
  String title;
  String category_name;
  String banner;
  String short_description;
  String description;
  ViewBook(this.id,this.title,this.category_name,this.banner,this.short_description,this.description);

  @override
  _ViewBookState createState() => _ViewBookState();
}

class _ViewBookState extends State<ViewBook> {

  List book = [ ];
  Future viewBook() async {
    var data = await getApi("beauty-book/${widget.id}");
    if (data['data'] != null) {
      for (int i = 0; i < data['data'].length; i++) {
        setState(() {
          book.add(data['data'][i]);
        });
      }
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
        title: Text("Book Details"),
        backgroundColor: Colors.pink,
      ),
      body: Container(
        child: Container(
          child: Column(
            children: <Widget>[
              widget.banner.contains('http')?Image.network(widget.banner):
              Image.asset(
                "assets/bb.jpg",
                fit: BoxFit.cover,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24,vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(width: MediaQuery.of(context).size.width/1.6,
                          child: Text(widget.title, style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w700,
                              fontSize: 15
                          ),),
                        ),
                        Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            SizedBox(height: 6,),
                            Text(widget.category_name, style: TextStyle(
                                color: Colors.teal,
                                fontSize: 14
                            ),)
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 30,),
                    Text(widget.short_description, style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                      letterSpacing: 0.6,
                      wordSpacing: 0.4,
                    ),),
                    SizedBox(height: 30,),
                    Text(widget.description, style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      letterSpacing: 0.6,
                      wordSpacing: 0.6,
                    ),),
                    SizedBox(height: 80,),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
