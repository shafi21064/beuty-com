
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kirei/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'dart:convert';
import 'package:kirei/repositories/payment_repository.dart';
import 'package:kirei/my_theme.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'order_success_page.dart';

class SslCommerzScreen extends StatefulWidget {
  double amount;
  String payment_type;
  String payment_method_key;
  String ssl_initial_url;
  int order_id;


  SslCommerzScreen(
      {Key key,
        this.amount = 0.00,
        this.payment_type = "",
        this.payment_method_key = "",
        this.order_id,
        this.ssl_initial_url})
      : super(key: key);

  @override
  _SslCommerzScreenState createState() => _SslCommerzScreenState();
}

class _SslCommerzScreenState extends State<SslCommerzScreen> {
  int _combined_order_id = 0;
  bool _order_init = false;


  WebViewController _webViewController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }



  getSetInitialUrl() async {
    var sslUrlResponse = await PaymentRepository().getSslcommerzBeginResponse(
        widget.payment_type, widget.order_id, widget.amount);

    if (sslUrlResponse.result == false) {
      ToastComponent.showDialog(sslUrlResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      Navigator.of(context).pop();
      return;
    }




    setState(() {});


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
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_)=> OrderSuccessPage(
              orderId: widget.order_id,
              message:responseJSON["message"],
              type: "danger",
            )), (route) => false);
      } else if (responseJSON["result"] == true) {
        payment_details = responseJSON['payment_details'];
        onPaymentSuccess(payment_details);
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
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_)=> OrderSuccessPage(
            orderId: widget.order_id,
            message:bkashPaymentProcessResponse.message,
            type: "danger",
          )), (route) => false);
      return;
    }

    Toast.show(bkashPaymentProcessResponse.message, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);

    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (_)=> OrderSuccessPage(
          orderId: widget.order_id,
          message: bkashPaymentProcessResponse.message,
          type: "success",
        )), (route) => false);
  }

  buildBody() {



    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.9,
        child: WebView(
          debuggingEnabled: false,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            _webViewController = controller;
            _webViewController.loadUrl(widget.ssl_initial_url);
          },
          onWebResourceError: (error) {
            print(error);
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (_)=> OrderSuccessPage(
                  orderId: widget.order_id,
                  message:"Something went wrong.",
                  type: "danger",
                )), (route) => false);
          },
          onPageFinished: (page) {
            print(page.toString());

            if (page.contains("status=success")) {
              //getData();
              Toast.show('Order Successful', context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);

              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (_)=> OrderSuccessPage(
                    orderId: widget.order_id,
                    message: 'Order Successful',
                    type: "success",
                  )), (route) => false);

            } else if (page.contains("status=failure") || page.contains("status=DECLINED")) {
              Toast.show("Payment Cancelled", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (_)=> OrderSuccessPage(
                    orderId: widget.order_id,
                    message:"Payment Cancelled",
                    type: "danger",
                  )), (route) => false);
              return;
            }
          },
        ),
      ),
    );
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
        AppLocalizations.of(context).sslcommerz_screen_pay_with_sslcommerz,
        style: TextStyle(fontSize: 16, color: MyTheme.primary),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }
}
