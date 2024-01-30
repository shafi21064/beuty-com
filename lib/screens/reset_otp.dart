import 'package:kirei/helpers/auth_helper.dart';
import 'package:kirei/my_theme.dart';
import 'package:kirei/screens/main.dart';
import 'package:kirei/screens/password_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kirei/custom/input_decorations.dart';
import 'package:kirei/screens/login.dart';
import 'package:kirei/repositories/auth_repository.dart';
import 'package:kirei/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResetOTP extends StatefulWidget {
  ResetOTP({Key key, this.phone}) : super(key: key);

  String phone;

  @override
  _ResetOtpState createState() => _ResetOtpState();
}

class _ResetOtpState extends State<ResetOTP> {
  //controllers
  TextEditingController _verificationCodeController = TextEditingController();

  @override
  void initState() {
    //on Splash Screen hide statusbar
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  void dispose() {
    //before going to other screen show statusbar
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  onPressConfirm() async {
    var code = _verificationCodeController.text.toString();

    if (code == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context).otp_screen_verification_code_warning,
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    }
    print(widget.phone);
    var passwordConfirmResponse =
        await AuthRepository().getPasswordConfirmResponse(code, widget.phone);

    if (passwordConfirmResponse.result == false) {
      ToastComponent.showDialog(passwordConfirmResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    } else {
      ToastComponent.showDialog(passwordConfirmResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PasswordOtp(
          phone: widget.phone,
          code: code,
        );
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    final _screen_height = MediaQuery.of(context).size.height;
    final _screen_width = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              width: _screen_width * (3 / 4),
              // child: Image.asset(
              //     "assets/splash_login_registration_background_image.png"),
            ),
            Container(
              width: double.infinity,
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, bottom: 15),
                    child: Container(
                      width: 75,
                      height: 75,
                      child: Image.asset(
                          'assets/login_registration_form_logo.png'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      "${AppLocalizations.of(context).otp_screen_verify_your} " +
                          AppLocalizations.of(context).otp_screen_phone_number,
                      style: TextStyle(
                          color: MyTheme.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    width: _screen_width * (3 / 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                height: 36,
                                child: TextField(
                                  controller: _verificationCodeController,
                                  autofocus: false,
                                  decoration:
                                      InputDecorations.buildInputDecoration_1(
                                          hint_text: "A X B 4 J H"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: MyTheme.light_grey, width: 1),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(12.0))),
                            child: FlatButton(
                              minWidth: MediaQuery.of(context).size.width,
                              //height: 50,
                              color: MyTheme.primary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0))),
                              child: Text(
                                AppLocalizations.of(context).otp_screen_confirm,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                              onPressed: () {
                                onPressConfirm();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}
