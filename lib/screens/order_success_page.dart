import 'package:flutter/material.dart';
import 'package:kirei/my_theme.dart';
import 'package:kirei/screens/main.dart';
import 'package:kirei/screens/order_details.dart';
import 'package:kirei/screens/order_list.dart';

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({Key key}): super(key: key);

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(color: MyTheme.primary),
      ),
      title: Text(
        "Order Status",
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * 1;
    return Scaffold(
      
      appBar: buildAppBar(context),
      
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 100,
            margin: EdgeInsets.symmetric(horizontal: 16),
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              //color: Colors.green,
              border: Border.all(
                width: 2,
                color: Colors.green,
              )
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: Icon(Icons.done, color: MyTheme.white,),
                  ),
                  Text("Successfully Ordered",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.secondary,
                  ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),

          InkWell(
            onTap: ()=> Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(builder: (_)=> Main()), (route) => false),
            child: Container(
              height: 50,
              width: 160,
              decoration: BoxDecoration(
                color: MyTheme.secondary,
              ),
              child: Center(
                child: Text("Home",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: MyTheme.white,
                  fontSize: 16
                ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          InkWell(
            onTap: ()=> Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(builder: (_)=> OrderList()), (route) => false),
            child: Container(
              height: 50,
              width: 160,
              decoration: BoxDecoration(
                color: MyTheme.secondary,
              ),
              child: Center(
                child: Text("Order History",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MyTheme.white,
                      fontSize: 16
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
