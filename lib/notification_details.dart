import 'package:flutter/material.dart';
import 'package:kirei/my_theme.dart';
import 'package:kirei/screens/main.dart';

class NotificationDetails extends StatefulWidget {
   NotificationDetails( this.title,  this.body);
  
  String title;
  String body;
  
  @override
  State<NotificationDetails> createState() => _NotificationDetailsState();
}

class _NotificationDetailsState extends State<NotificationDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: MyTheme.primary,
        leading: IconButton(
            onPressed: (){
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> Main(pageIndex: 0,)), (route) => false);
            },
            icon: Icon(Icons.arrow_back)
        ),
        centerTitle: true,
        title: Text("Notification Details",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: MyTheme.white
        ),
        ),
      ),
      
      body: Container(
        padding: EdgeInsets.only(
          //top: 10,
          left: 5,
          right: 5
        ),
        margin: EdgeInsets.only(
          top: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Text(widget.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: MyTheme.secondary,
              fontSize: 22,
            ),
            ),
            
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.018,
            ),

            Text(widget.body,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: MyTheme.secondary,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      
    );
  }
}
