
import 'package:kirei/helpers/auth_helper.dart';
import 'package:kirei/my_theme.dart';
import 'package:kirei/screens/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kirei/custom/input_decorations.dart';
import 'package:kirei/repositories/auth_repository.dart';
import 'package:kirei/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Otp extends StatefulWidget {
  Otp(
      {Key key,
      this.verify_by,
      this.user_id,
      this.phoneNumber,
      this.responseData,
      this.prev_screen})
      : super(key: key);
  final String verify_by;
  final String prev_screen;
  final int user_id;
  final String phoneNumber;
  final Object responseData;

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  //controllers
  TextEditingController _verificationCodeController = TextEditingController();




  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  void dispose() {
    //before going to other screen show statusbar
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }



  onTapResend() async {
    var resendCodeResponse = await AuthRepository()
        .getResendCodeResponse(int.parse(widget.phoneNumber),);

    if (resendCodeResponse.result == false) {
      ToastComponent.showDialog(resendCodeResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    } else {
      ToastComponent.showDialog(resendCodeResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    }
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
    if (widget.verify_by == 'otp') {
      var confirmCodeResponse = widget.prev_screen == "Login"
          ? await AuthRepository()
              .getLogInOtpConfirmCodeResponse(widget.phoneNumber, code)
          : await AuthRepository()
              .getSignUpOtpConfirmCodeResponse(widget.phoneNumber, code);

      if (confirmCodeResponse == false) {

      } else {

        print(widget.responseData);
        AuthHelper().setUserDataFromOTP(confirmCodeResponse);

        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Main();
        }));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String _verify_by = widget.verify_by; //phone or email
    final _screen_height = MediaQuery.of(context).size.height;
    final _screen_width = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [

            Container(
              width: double.infinity,
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 70.0, bottom: 15),
                    child: Container(
                      width: 75,
                      height: 75,
                      child: Image.asset('assets/logo.png'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      "${AppLocalizations.of(context).otp_screen_verify_your} " +
                          (_verify_by == "email"
                              ? AppLocalizations.of(context)
                                  .otp_screen_email_account
                              : AppLocalizations.of(context)
                                  .otp_screen_phone_number),
                      style: TextStyle(
                          color: MyTheme.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Container(
                        width: _screen_width * (3 / 4),
                        child: _verify_by == "email"
                            ? Text(
                                AppLocalizations.of(context)
                                    .otp_screen_enter_verification_code_to_email,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: MyTheme.dark_grey, fontSize: 14))
                            : Text(
                                AppLocalizations.of(context)
                                    .otp_screen_enter_verification_code_to_phone,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: MyTheme.dark_grey, fontSize: 14))),
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
                          padding:  EdgeInsets.only(top: 40.0, left: 0, right: 0,bottom: 8),
                          child: RaisedButton(
                            onPressed: (){
                              onPressConfirm();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2.0)),
                            padding: EdgeInsets.all(0.0),
                            child: Ink(
                              decoration:
                              BoxDecoration(color: MyTheme.secondary),
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: 300.0, minHeight: 50.0),
                                alignment: Alignment.center,
                                      child: Text(
                                        AppLocalizations.of(context).otp_screen_confirm,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 100),
                    child: InkWell(
                      onTap: () {
                        onTapResend();
                      },
                      child: Text(
                          AppLocalizations.of(context).otp_screen_resend_code,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: MyTheme.primary,
                              decoration: TextDecoration.underline,
                              fontSize: 13)),
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
