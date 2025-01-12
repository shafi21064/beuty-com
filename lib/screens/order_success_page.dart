import 'package:flutter/material.dart';
import 'package:kirei/helpers/shimmer_helper.dart';
import 'package:kirei/my_theme.dart';
import 'package:kirei/providers/cart_count_update.dart';
import 'package:kirei/repositories/order_repository.dart';
import 'package:kirei/screens/main.dart';
import 'package:kirei/screens/order_list.dart';
import 'package:provider/provider.dart';

class OrderSuccessPage extends StatefulWidget {
  int orderId;
  String message;
  String type;

   OrderSuccessPage({Key key,
     this.orderId,
     this.message,
     this.type
   }): super(key: key);


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



    super.initState();
  }

  var orderDetails;
  var orderedItemList;

  fetchOrderDetails() async {
    var orderDetailsResponse =
    await OrderRepository().getOrderDetails(id: widget.orderId);

    if (orderDetailsResponse.detailed_orders.length > 0) {

      orderDetails = orderDetailsResponse.detailed_orders[0];

    }

    setState(() {});
  }

  fetchOrderedItems() async {
    var orderItemResponse =
    await OrderRepository().getOrderItems(id: widget.orderId);
    orderedItemList.addAll(orderItemResponse.ordered_items);


    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * 1;
    final cartCountUpdate = Provider.of<CartCountUpdate>(context);
    return Scaffold(

      appBar: buildAppBar(context),

      body: orderDetails == null ? ShimmerHelper().buildAddressLoadingShimmer() :
      Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           widget.type == "success" ?  Container(
              height: 100,
              margin: EdgeInsets.symmetric(horizontal: 16),
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
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
            ) :
           Container(
             height: 100,
             margin: EdgeInsets.symmetric(horizontal: 16),
             width: width,
             decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(10),
                 border: Border.all(
                   width: 2,
                   color: MyTheme.primary,
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
                       color: MyTheme.primary,
                     ),
                     child: Icon(Icons.cancel, color: MyTheme.white,),
                   ),
                   Text("${widget.message}",
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


            Text("Order Summary",
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
                            fontSize: 16,
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
                      Text(orderDetails.subtotal != null ? "${orderDetails.subtotal.toString()}" : "",
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
              onTap: (){ Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute(builder: (_)=> OrderList(
                from_checkout: true,
              )), (route) => false);
              cartCountUpdate.getReset();
              },
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
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),

            InkWell(
              onTap: (){ Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute(builder: (_)=> Main()), (route) => false);
                cartCountUpdate.getReset();
              },
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
      ) ,
    );
  }
}

