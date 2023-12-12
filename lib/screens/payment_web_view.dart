import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:active_ecommerce_flutter/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebviewScreen extends StatefulWidget {
  PaymentWebviewScreen({Key key, this.url}) : super(key: key);

  final String url;

  @override
  _PaymentWebviewScreenState createState() => _PaymentWebviewScreenState();
}

class _PaymentWebviewScreenState extends State<PaymentWebviewScreen> {
  String _urlLoaded;

  @override
  void initState() {
    super.initState();
    _urlLoaded = widget.url;
    _checkPaymentStatus();
  }

  void _checkPaymentStatus() {
    final Uri parsedUrl = Uri.parse(_urlLoaded);
    if (parsedUrl.pathSegments.contains("success")) {
      ToastComponent.showDialog("Payment Successful", context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: widget.url,
      javascriptMode: JavascriptMode.unrestricted,
      onPageStarted: (url) {
        setState(() {
          _urlLoaded = url;
        });
        _checkPaymentStatus();
      },
    );
  }
}
