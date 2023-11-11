import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:active_ecommerce_flutter/custom/input_decorations.dart';
import 'package:active_ecommerce_flutter/custom/intl_phone_input.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:active_ecommerce_flutter/screens/otp.dart';
import 'package:active_ecommerce_flutter/screens/login.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:active_ecommerce_flutter/repositories/auth_repository.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String _register_by = "otp"; //phone or email
  String initialCountry = 'BD';
  PhoneNumber phoneCode = PhoneNumber(isoCode: 'BD', dialCode: "+880");

  String _phone = "";
  bool validPhoneNumber = false;

  //controllers
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();

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

  onPressSignUp() async {
    var name = _nameController.text.toString();
    var email = _emailController.text.toString();
    var password = _passwordController.text.toString();
    var password_confirm = _passwordConfirmController.text.toString();
    var _phone = _phoneNumberController.text.toString();

    if (_register_by == 'phone' && name == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context).registration_screen_name_warning,
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    } else if (_register_by == 'email' && email == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context).registration_screen_email_warning,
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    } else if (_register_by == 'phone' && _phone == "" && !validPhoneNumber) {
      ToastComponent.showDialog(
          AppLocalizations.of(context).registration_screen_phone_warning,
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    } else if (_register_by == 'phone' && password == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context).registration_screen_password_warning,
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    } else if (_register_by == 'phone' && password_confirm == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context)
              .registration_screen_password_confirm_warning,
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    } else if (_register_by == 'phone' && password.length < 6) {
      ToastComponent.showDialog(
          AppLocalizations.of(context)
              .registration_screen_password_length_warning,
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    } else if (_register_by == 'phone' && password != password_confirm) {
      ToastComponent.showDialog(
          AppLocalizations.of(context)
              .registration_screen_password_match_warning,
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG);
      return;
    } else if (_register_by == "otp") {
      var signupResponse = await AuthRepository().getSignupOtpResponse(_phone);
      if (signupResponse.result == false) {
        ToastComponent.showDialog(signupResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      } else {
        ToastComponent.showDialog(signupResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Otp(
            verify_by: _register_by,
            phoneNumber: signupResponse.phone,
            responseData: signupResponse,
            // user_id: signupResponse.user_id,
          );
        }));
      }
      return;
    }
    var signupResponse = await AuthRepository().getSignupResponse(
        name,
        _register_by == 'email' ? email : _phone,
        password,
        password_confirm,
        _register_by);

    if (signupResponse.result == false) {
      ToastComponent.showDialog(signupResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    } else {
      ToastComponent.showDialog(signupResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Otp(
          verify_by: _register_by,
          user_id: signupResponse.user_id,
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
            // Container(
            //   width: _screen_width * (3 / 4),
            //   child: Image.asset("assets/image_02.png"),
            // ),
            Container(
              width: double.infinity,
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, bottom: 15),
                    child: Container(
                      width: 120,
                      child: Image.asset('assets/logo.png'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      "Register",
                      style: TextStyle(
                          color:
                              Theme.of(context).buttonTheme.colorScheme.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    width: _screen_width * (3 / 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: _register_by == 'phone',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  AppLocalizations.of(context)
                                      .registration_screen_name,
                                  style: TextStyle(
                                    color: MyTheme.accent_color,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Container(
                                  height: 36,
                                  child: TextField(
                                    controller: _nameController,
                                    autofocus: false,
                                    decoration:
                                        InputDecorations.buildInputDecoration_1(
                                      hint_text: "Farhan Khan",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            AppLocalizations.of(context)
                                .registration_screen_phone,
                            style: TextStyle(
                                color: MyTheme.accent_color,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        // if (_register_by == "email")
                        //   Padding(
                        //     padding: const EdgeInsets.only(bottom: 8.0),
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.end,
                        //       children: [
                        //         Container(
                        //           height: 36,
                        //           child: TextField(
                        //             controller: _emailController,
                        //             autofocus: false,
                        //             decoration:
                        //                 InputDecorations.buildInputDecoration_1(
                        //                     hint_text: "johndoe@example.com"),
                        //           ),
                        //         ),
                        //         // GestureDetector(
                        //         //         onTap: () {
                        //         //           setState(() {
                        //         //             _register_by = "phone";
                        //         //           });
                        //         //         },
                        //         //         child: Text(
                        //         //           AppLocalizations.of(context)
                        //         //               .registration_screen_or_register_with_phone,
                        //         //           style: TextStyle(
                        //         //               color: MyTheme.accent_color,
                        //         //               fontStyle: FontStyle.italic,
                        //         //               decoration:
                        //         //                   TextDecoration.underline),
                        //         //         ),
                        //         //       )

                        //       ],
                        //     ),
                        //   )

                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                height: 36,
                                child: CustomInternationalPhoneNumberInput(
                                  onInputChanged: (PhoneNumber number) {
                                    print(number.phoneNumber);
                                    setState(() {
                                      _phone = number.phoneNumber;
                                    });
                                  },
                                  onInputValidated: (bool value) {
                                    if (value) {
                                      // Valid phone number, do something
                                      validPhoneNumber = true;
                                    } else {
                                      // Invalid phone number, show an error
                                      _phone = "";
                                    }
                                  },
                                  selectorConfig: SelectorConfig(
                                    selectorType: PhoneInputSelectorType.DIALOG,
                                  ),
                                  ignoreBlank: false,
                                  autoValidateMode: AutovalidateMode.disabled,
                                  selectorTextStyle:
                                      TextStyle(color: MyTheme.font_grey),
                                  initialValue: phoneCode,
                                  textFieldController: _phoneNumberController,
                                  formatInput: true,
                                  keyboardType: TextInputType.numberWithOptions(
                                      signed: true, decimal: true),
                                  inputDecoration: InputDecorations
                                      .buildInputDecoration_phone(
                                          hint_text: "01710 333 558"),
                                  onSaved: (PhoneNumber number) {
                                    //print('On Saved: $number');
                                  },
                                  countries: ["BD"],
                                ),
                              ),
                            ],
                          ),
                        ),

                        Visibility(
                          visible: _register_by == 'phone',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  AppLocalizations.of(context)
                                      .registration_screen_password,
                                  style: TextStyle(
                                    color: MyTheme.accent_color,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 36,
                                      child: TextField(
                                        controller: _passwordController,
                                        autofocus: false,
                                        obscureText: true,
                                        enableSuggestions: false,
                                        autocorrect: false,
                                        decoration: InputDecorations
                                            .buildInputDecoration_1(
                                          hint_text: "• • • • • • • •",
                                        ),
                                      ),
                                    ),
                                    Text(
                                      AppLocalizations.of(context)
                                          .registration_screen_password_length_recommendation,
                                      style: TextStyle(
                                        color: MyTheme.textfield_grey,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  AppLocalizations.of(context)
                                      .registration_screen_retype_password,
                                  style: TextStyle(
                                    color: MyTheme.accent_color,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Container(
                                  height: 36,
                                  child: TextField(
                                    controller: _passwordConfirmController,
                                    autofocus: false,
                                    obscureText: true,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    decoration:
                                        InputDecorations.buildInputDecoration_1(
                                      hint_text: "• • • • • • • •",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            onPressed: onPressSignUp,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(.0)),
                            padding: EdgeInsets.all(0.0),
                            child: Ink(
                              decoration:
                                  BoxDecoration(color: MyTheme.send_otp),
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: 300.0, minHeight: 50.0),
                                alignment: Alignment.center,
                                child: Text(
                                  _register_by != "otp"
                                      ? "REGISTER"
                                      : "SEND OTP",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.openSans(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Center(
                              child: Text(
                            "Or, Register with",
                            style: TextStyle(
                                color: MyTheme.medium_grey, fontSize: 12),
                          )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _register_by != "otp"
                              ? RaisedButton(
                                  onPressed: () {
                                    setState(() {
                                      _register_by = "otp";
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2.0)),
                                  padding: EdgeInsets.all(0.0),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: Container(
                                      constraints: BoxConstraints(
                                          maxWidth: 300.0, minHeight: 50.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "SIGN UP WITH OTP !",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.openSans(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                )
                              : RaisedButton(
                                  onPressed: () {
                                    setState(() {
                                      _register_by = "phone";
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2.0)),
                                  padding: EdgeInsets.all(0.0),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      color: MyTheme.sign_up_with_password,
                                    ),
                                    child: Container(
                                      constraints: BoxConstraints(
                                          maxWidth: 300.0, minHeight: 50.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Sign Up With Password",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.openSans(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            onPressed: () {
                              setState(() {
                                _register_by = "otp";
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                            padding: EdgeInsets.all(0.0),
                            child: Ink(
                              decoration:
                                  BoxDecoration(color: MyTheme.facebook_login),
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: 300.0, minHeight: 50.0),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons
                                          .facebook_outlined, // You can replace this with the Google Icon
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "REGISTER WITH FACEBOOK",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.openSans(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            onPressed: () {
                              setState(() {
                                _register_by = "otp";
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                            padding: EdgeInsets.all(0.0),
                            child: Ink(
                              decoration:
                                  BoxDecoration(color: MyTheme.google_login),
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: 300.0, minHeight: 50.0),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/icon_google.png', // Replace with the actual path to your Google icon
                                      // Adjust the width as needed
                                      color: Colors
                                          .white, // Set the desired color for the icon
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "REGISTER WITH GOOGLE",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.openSans(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Login();
                            }));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Center(
                                child: Text(
                              "Login Now ! ",
                              style: TextStyle(
                                  color: MyTheme.dont_have_account,
                                  fontWeight: FontWeight.bold,
                                  // Add this line for underline
                                  fontSize: 16),
                            )),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: RaisedButton(
                        //     onPressed: () {
                        //       Navigator.push(context,
                        //           MaterialPageRoute(builder: (context) {
                        //         return Login();
                        //       }));
                        //     },
                        //     shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(2.0)),
                        //     padding: EdgeInsets.all(0.0),
                        //     child: Ink(
                        //       decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(10.0)),
                        //       child: Container(
                        //         constraints: BoxConstraints(
                        //             maxWidth: 300.0, minHeight: 50.0),
                        //         alignment: Alignment.center,
                        //         child: Text(
                        //           "Sign In",
                        //           textAlign: TextAlign.center,
                        //           style: GoogleFonts.openSans(
                        //               color: Colors.white, fontSize: 16),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  )
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}
