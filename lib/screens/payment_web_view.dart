import 'package:kirei/custom/toast_component.dart';
import 'package:kirei/my_theme.dart';
import 'package:kirei/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentWebviewScreen extends StatefulWidget {
  PaymentWebviewScreen({Key key, this.url}) : super(key: key);

  final String url;

  @override
  _PaymentWebviewScreenState createState() => _PaymentWebviewScreenState();
}

class _PaymentWebviewScreenState extends State<PaymentWebviewScreen> {
  String _urlLoaded;
  WebViewController _webViewController;

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: buildBody(),
    );
  }

  buildBody() {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: WebView(
          debuggingEnabled: false,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            _webViewController = controller;
            _webViewController.loadUrl(widget.url);
          },
          onWebResourceError: (error) {},
          onPageFinished: (page) {

            if (page.contains("/bkash/api/success")) {
              ToastComponent.showDialog("Payment Successfull", context,
                  gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
              Navigator.of(context).pop();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(),
                ),
              );
            } else if (page.contains("/bkash/api/fail")) {
              ToastComponent.showDialog("Payment cancelled", context,
                  gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
              Navigator.of(context).pop();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(),
                ),
              );
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
        AppLocalizations.of(context).bkash_screen_pay_with_bkash,
        style: TextStyle(fontSize: 16, color: MyTheme.primary),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }
}
