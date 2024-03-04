import 'package:flutter/material.dart';
import 'package:kirei/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'dart:convert';
import 'package:kirei/repositories/payment_repository.dart';
import 'package:kirei/my_theme.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:kirei/screens/order_list.dart';
import 'package:kirei/screens/wallet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'order_success_page.dart';

class BkashScreen extends StatefulWidget {
  double amount;
  String payment_type;
  String payment_method_key;
  int order_id;

  BkashScreen(
      {Key key,
      this.amount = 0.00,
      this.payment_type = "",
      this.payment_method_key = "",
      this.order_id})
      : super(key: key);

  @override
  _BkashScreenState createState() => _BkashScreenState();
}

class _BkashScreenState extends State<BkashScreen> {
  int _combined_order_id = 0;
  bool _order_init = false;
  String _initial_url = "";
  bool _initial_url_fetched = false;

  WebViewController _webViewController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // if (widget.payment_type == "cart_payment") {
    //   createOrder();
    // }

    // if (widget.payment_type != "cart_payment") {
    //   // on cart payment need proper order id
       getSetInitialUrl();
    // }
  }

  createOrder() async {
    var orderCreateResponse = await PaymentRepository()
        .getOrderCreateResponse(widget.payment_method_key);

    if (orderCreateResponse.result == false) {
      ToastComponent.showDialog(orderCreateResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      Navigator.of(context).pop();
      return;
    }

    _combined_order_id = orderCreateResponse.combined_order_id;
    _order_init = true;
    setState(() {});

    getSetInitialUrl();
  }

  getSetInitialUrl() async {
    var bkashUrlResponse = await PaymentRepository().getBkashBeginResponse(
        widget.payment_type, widget.order_id, widget.amount);

    print('bkash result3 ${bkashUrlResponse.message}');
    print('bkash result ${bkashUrlResponse.url}');
    print('bkash result ${bkashUrlResponse.result}');
    print('bkash result ${bkashUrlResponse.token}');

    if (bkashUrlResponse.result == false) {
      ToastComponent.showDialog(bkashUrlResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      Navigator.of(context).pop();
      return;
    }

    _initial_url = bkashUrlResponse.url;
    _initial_url_fetched = true;

    setState(() {});

   // print(_initial_url);
    // print(_initial_url_fetched);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: buildBody(),
    );
  }

  void getData() {
     print('bkash 00');
    var payment_details = '';
    _webViewController
        .evaluateJavascript("document.body.innerText")
        .then((data) {
      var decodedJSON = jsonDecode(data);
      Map<String, dynamic> responseJSON = jsonDecode(decodedJSON);

      print('Bkash json Response' +decodedJSON.toString());

      if (responseJSON["result"] == false) {
        Toast.show(responseJSON["message"], context,
            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
        Navigator.pop(context);
      } else if (responseJSON["result"] == true) {
        payment_details = responseJSON['payment_details'];
         print('payment success');
         //return true;
        ToastComponent.showDialog(
          responseJSON["message"],
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG,
        );
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_)=> OrderSuccessPage(
              orderId: widget.order_id,
            )), (route) => false);
        //onPaymentSuccess(payment_details);
      }
    });
  }

  onPaymentSuccess(payment_details) async {
    var bkashPaymentProcessResponse = await PaymentRepository()
        .getBkashPaymentProcessResponse(widget.payment_type, widget.amount,
            _combined_order_id, payment_details);

    if (bkashPaymentProcessResponse.result == false) {
      Toast.show(bkashPaymentProcessResponse.message, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      Navigator.pop(context);
      return;
    }

    Toast.show(bkashPaymentProcessResponse.message, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    // if (widget.payment_type == "cart_payment") {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return OrderList(from_checkout: true);
      }));
    // } else if (widget.payment_type == "wallet_payment") {
    //   Navigator.push(context, MaterialPageRoute(builder: (context) {
    //     return Wallet(from_recharge: true);
    //   }));
    // }
  }

  buildBody() {
     print('bkash link: ${_initial_url}');
     print('bkash link2: ${_initial_url_fetched}');
    //
    // if (_order_init == false &&
    //     _combined_order_id == 0 &&
    //     widget.payment_type == "cart_payment") {
    //   return Container(
    //     child: Center(
    //       child: Text(AppLocalizations.of(context).common_creating_order),
    //     ),
    //   );
    // } else
      if (_initial_url_fetched == false) {
      return Container(
        child: Center(
          child: Text(
              AppLocalizations.of(context).bkash_screen_fetching_bkash_url),
        ),
      );
    } else {
        print('bkash 22');
      return SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: WebView(
            debuggingEnabled: false,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) {
              _webViewController = controller;
              _webViewController.loadUrl(_initial_url);
            },
            onWebResourceError: (error) {
              print('bkash 11');
            },
            onPageFinished: (page) {
              // print(page.toString());
              // getData();
              // print("page link: + ${page.toString()}");
              if (page.contains("/bkash/api/callback")) {
                getData();
              } else if (page.contains("/bkash/api/fail")) {
                ToastComponent.showDialog("Payment cancelled", context,
                    gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
                Navigator.of(context).pop();
                return;
              }
            },
          ),
        ),
      );
    }
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        AppLocalizations.of(context).bkash_screen_pay_with_bkash,
        style: TextStyle(fontSize: 16, color: MyTheme.primary),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }
}
