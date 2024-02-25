import 'package:flutter/material.dart';
import 'package:kirei/my_theme.dart';
import 'package:kirei/repositories/order_repository.dart';
import 'package:kirei/screens/main.dart';
import 'package:kirei/screens/order_details.dart';
import 'package:kirei/screens/order_list.dart';

class OrderSuccessPage extends StatefulWidget {
   OrderSuccessPage({Key key, this.orderId}): super(key: key);

  int orderId;

  @override
  State<OrderSuccessPage> createState() => _OrderSuccessPageState();
}

class _OrderSuccessPageState extends State<OrderSuccessPage> {
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
  void initState() {
    // TODO: implement initState
    fetchOrderDetails();
    fetchOrderedItems();
    print("UserID1:${orderDetails?.user_id}");
    super.initState();
  }

  var orderDetails;
  var orderedItemList;

  fetchOrderDetails() async {
    var orderDetailsResponse =
    await OrderRepository().getOrderDetails(id: widget.orderId);

    if (orderDetailsResponse.detailed_orders.length > 0) {
      //orderDetails = orderDetailsResponse.detailed_orders[0];
      orderDetails = orderDetailsResponse.detailed_orders[0];
    }

    setState(() {});
  }

  fetchOrderedItems() async {
    var orderItemResponse =
    await OrderRepository().getOrderItems(id: widget.orderId);
    orderedItemList.addAll(orderItemResponse.ordered_items);
    //orderItemsInit = true;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * 1;
    return Scaffold(

      appBar: buildAppBar(context),

      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Column(
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
              height: MediaQuery.of(context).size.height * 0.03,
            ),

            // InkWell(
            //   onTap: ()=> Navigator.pushAndRemoveUntil(
            //       context, MaterialPageRoute(builder: (_)=> OrderList()), (route) => false),
            //   child: Container(
            //     height: 50,
            //     width: 160,
            //     decoration: BoxDecoration(
            //       color: MyTheme.secondary,
            //     ),
            //     child: Center(
            //       child: Text("Order History",
            //         style: TextStyle(
            //             fontWeight: FontWeight.bold,
            //             color: MyTheme.white,
            //             fontSize: 16
            //         ),
            //       ),
            //     ),
            //   ),
            // ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text("Order Number"),
            //         SizedBox(
            //           height: MediaQuery.of(context).size.height * 0.01,
            //         ),
            //         Text("${orderDetails?.id.toString()}",
            //         style: TextStyle(
            //           fontWeight: FontWeight.bold
            //         ),
            //         ),
            //       ],
            //     ),
            //     Column(
            //       children: [
            //         Text("Date"),
            //         SizedBox(
            //           height: MediaQuery.of(context).size.height * 0.01,
            //         ),
            //         Text("${orderDetails?.date.toString()}",
            //           style: TextStyle(
            //               fontWeight: FontWeight.bold
            //           ),
            //         ),
            //       ],
            //     ),
            //     Column(
            //       children: [
            //         Text("Total"),
            //         SizedBox(
            //           height: MediaQuery.of(context).size.height * 0.01,
            //         ),
            //         Text("${orderDetails?.grand_total.toString()}",
            //           style: TextStyle(
            //               fontWeight: FontWeight.bold
            //           ),
            //         ),
            //       ],
            //     ),
            //     Column(
            //       children: [
            //         Text("Payment Method"),
            //         SizedBox(
            //           height: MediaQuery.of(context).size.height * 0.01,
            //         ),
            //         Text("${orderDetails?.payment_type.toString()}",
            //           style: TextStyle(
            //               fontWeight: FontWeight.bold
            //           ),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),

            Text("Order Summery",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: MyTheme.secondary
            ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Order Number",
                        style: TextStyle(
                            fontSize: 14,
                            color: MyTheme.secondary,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text("${orderDetails?.id.toString()}",
                        style: TextStyle(
                            fontSize: 14,
                            color: MyTheme.secondary,
                            fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text("Subtotal",
                        style: TextStyle(
                            fontSize: 14,
                            color: MyTheme.secondary,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text("${orderDetails.subtotal.toString()}",
                        style: TextStyle(
                            fontSize: 14,
                            color: MyTheme.secondary,
                            fontWeight: FontWeight.bold
                      ),
                      )
                    ],
                  ),

                  Divider(
                    height: 1,
                    thickness: 1,
                    color: MyTheme.dark_grey,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text("Coupon Discount",
                        style: TextStyle(
                            fontSize: 14,
                            color: MyTheme.secondary,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text("${orderDetails.coupon_discount.toString()}",
                        style: TextStyle(
                            fontSize: 14,
                            color: MyTheme.secondary,
                            fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),

                  Divider(
                    height: 1,
                    thickness: 1,
                    color: MyTheme.dark_grey,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text("Delivery Charge",
                        style: TextStyle(
                            fontSize: 14,
                            color: MyTheme.secondary,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text("${orderDetails.shipping_cost.toString()}",
                        style: TextStyle(
                            fontSize: 14,
                            color: MyTheme.secondary,
                            fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),

                  Divider(
                    height: 1,
                    thickness: 1,
                    color: MyTheme.dark_grey,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text("Total",
                        style: TextStyle(
                            fontSize: 14,
                            color: MyTheme.secondary,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text("${orderDetails.grand_total.toString()}",
                        style: TextStyle(
                            fontSize: 14,
                            color: MyTheme.secondary,
                            fontWeight: FontWeight.bold
                        ),
                      )

                    ],
                  ),

                ],
              ),
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
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
          ],
        ),
      ),
    );
  }
}

