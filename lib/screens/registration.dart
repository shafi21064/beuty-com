import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kirei/helpers/auth_helper.dart';
import 'package:kirei/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kirei/custom/input_decorations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:kirei/other_config.dart';
import 'package:kirei/repositories/profile_repository.dart';
import 'package:kirei/screens/otp.dart';
import 'package:kirei/screens/login.dart';
import 'package:kirei/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'package:kirei/repositories/auth_repository.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'main.dart';

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
      var signupResponse = await AuthRepository().getSignupOtpResponse(_phone, context);
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
            prev_screen: 'Registration',
            // user_id: signupResponse.user_id,
          );
        }));
      }
      return;
    }
    var signupResponse = await AuthRepository().getSignupResponse(
        name,
        _register_by == 'email' ? email : _phone,
        //email,
        password,
        password_confirm,
        _register_by, context);

    if (signupResponse.result == false) {
      ToastComponent.showDialog(signupResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    } else {
      ToastComponent.showDialog(signupResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      AuthHelper().setUserData(signupResponse);
      // push notification starts
      if (OtherConfig.USE_PUSH_NOTIFICATION) {
        final FirebaseMessaging _fcm = FirebaseMessaging.instance;

        await _fcm.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );

        String fcmToken = await _fcm.getToken();

        if (fcmToken != null) {
          print("--fcm token--");
          print(fcmToken);
          if (is_logged_in.$ == true) {
            print("true------------------------");
            // update device token
            var deviceTokenUpdateResponse = await ProfileRepository()
                .getDeviceTokenUpdateResponse(fcmToken);
            print("hmmmm------------------------");
          }
        }
      }

      //push norification ends
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Main();
      }));
      ;
    }
  }

  onPressedFacebookLogin() async {
    final facebookLogin =
        await FacebookAuth.instance.login();

    if (facebookLogin.status == LoginStatus.success) {
      // get the user data
      // by default we get the userId, email,name and picture
      final userData = await FacebookAuth.instance.getUserData();
      var loginResponse = await AuthRepository().getSocialLoginResponse(
          "facebook",
          userData['name'].toString(),
          userData['email'].toString(),
          userData['id'].toString(),
          access_token: facebookLogin.accessToken.token);
      print("..........................${loginResponse.toString()}");
      if (loginResponse.result == false) {
        ToastComponent.showDialog(loginResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      } else {
        ToastComponent.showDialog(loginResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        AuthHelper().setUserData(loginResponse);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Main();
        }));
        FacebookAuth.instance.logOut();
      }
      // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");

    } else {
      print("....Facebook auth Failed.........");
      print(facebookLogin.status);
      print(facebookLogin.message);
    }
  }

  onPressedGoogleRegister() async {
    // try {
    //   print("Kireiapp");
    //   final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    //
    //   print(googleUser.toString());
    //
    //   GoogleSignInAuthentication googleSignInAuthentication =
    //       await googleUser.authentication;
    //   String accessToken = googleSignInAuthentication.accessToken;
    //
    //   var loginResponse = await AuthRepository().getSocialLoginResponse(
    //       "google", googleUser.displayName, googleUser.email, googleUser.id,
    //       access_token: accessToken);
    //   print("Kireiapp5");
    //   if (loginResponse.result == false) {
    //     print("Kireiapp5");
    //     ToastComponent.showDialog(loginResponse.message, context,
    //         gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    //   } else {
    //     print("Kireiapp6");
    //     ToastComponent.showDialog(loginResponse.message, context,
    //         gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    //     AuthHelper().setUserData(loginResponse);
    //     Navigator.push(context, MaterialPageRoute(builder: (context) {
    //       return Main();
    //     }));
    //   }
    //   GoogleSignIn().disconnect();
    // } on Exception catch (e) {
    //   print("error is ....... $e");
    //   // TODO
    // }

    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication googleAuth = await googleUser?.authentication;

      // final credential = GoogleAuthProvider.credential(
      //   accessToken: googleAuth?.accessToken,
      //   idToken: googleAuth?.idToken,
      // );

      var loginResponse = await AuthRepository().getSocialLoginResponse(
          "google", googleUser.displayName, googleUser.email, googleUser.id,
          access_token: googleAuth.accessToken);

      if (loginResponse.result == false) {
        ToastComponent.showDialog(loginResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      } else {
        ToastComponent.showDialog(loginResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        AuthHelper().setUserData(loginResponse);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Main();
        }));
      }
      GoogleSignIn().disconnect();

    } on Exception catch (e) {
      print("error is ....... $e");
      // TODO
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
                                    color: MyTheme.primary,
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
                                      hint_text: "Your Name",
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
                                color: MyTheme.primary,
                                fontWeight: FontWeight.w600),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0, ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                height: 36,
                                child: Container(
                                  height: 56,
                                  child: TextField(
                                    controller: _phoneNumberController,
                                    onChanged: (number) {
                                      _phone = "${number}";
                                      validPhoneNumber=true;
                                    },

                                    autofocus: false,
                                    autocorrect: true,
                                    decoration: InputDecoration(
                                      hintText: '01*********',
                                      hintStyle: TextStyle(color: Colors.grey),
                                      filled: true,
                                      fillColor: Colors.white70,
                                    ),
                                  ),
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
                                    color: MyTheme.primary,
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
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .registration_screen_password_length_recommendation,
                                        style: TextStyle(
                                          //color: MyTheme.light_grey,
                                          color: MyTheme.dark_grey,
                                          fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.w600, fontSize: 10, wordSpacing:1, letterSpacing: 0.1
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
                                      .registration_screen_retype_password,
                                  style: TextStyle(
                                    color: MyTheme.primary,
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
                          //padding: const EdgeInsets.all(8.0),
                          padding:  EdgeInsets.only(top: 8.0, left: 0, right: 0,bottom: 8),
                          child: RaisedButton(
                            onPressed: onPressSignUp,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(.0)),
                            padding: EdgeInsets.all(0.0),
                            child: Ink(
                              decoration:
                                  BoxDecoration(color: MyTheme.dark_grey),
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
                                color: MyTheme.dark_grey, fontSize: 12),
                          )),
                        ),
                        Padding(
                          //padding: const EdgeInsets.all(8.0),
                          padding:  EdgeInsets.only(top: 8.0, left: 0, right: 0,bottom: 8),
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
                        // Padding(
                        //   padding: const EdgeInsets.only(
                        //     top: 8.0, bottom: 8.0, right: 0.0, left: 0.0,
                        //   ),
                        //   child: RaisedButton(
                        //     onPressed: onPressedFacebookLogin,
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(2.0),
                        //     ),
                        //     padding: EdgeInsets.all(0.0),
                        //     child: Ink(
                        //       decoration:
                        //       BoxDecoration(color: MyTheme.facebook_bg),
                        //       child: Container(
                        //         constraints: BoxConstraints(
                        //             maxWidth: 300.0, minHeight: 50.0),
                        //         alignment: Alignment.center,
                        //         child: Row(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           children: [
                        //             Icon(
                        //               Icons
                        //                   .facebook_outlined, // You can replace this with the Google Icon
                        //               color: Colors.white,
                        //             ),
                        //             SizedBox(width: 10),
                        //             Text(
                        //               "LOGIN WITH FACEBOOK",
                        //               textAlign: TextAlign.center,
                        //               style: GoogleFonts.ubuntu(
                        //                   color: Colors.white, fontSize: 16),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        // Padding(
                        //   padding: const EdgeInsets.only(
                        //     top: 8.0, bottom: 8.0, right: 0.0, left: 0.0,
                        //   ),
                        //   child: RaisedButton(
                        //     onPressed: onPressedGoogleRegister,
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(2.0),
                        //     ),
                        //     padding: EdgeInsets.all(0.0),
                        //     child: Ink(
                        //       decoration:
                        //       BoxDecoration(color: MyTheme.google_bg),
                        //       child: Container(
                        //         constraints: BoxConstraints(
                        //             maxWidth: 300.0, minHeight: 50.0),
                        //         alignment: Alignment.center,
                        //         child: Row(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           children: [
                        //             Image.asset(
                        //               'assets/icon_google.png', // Replace with the actual path to your Google icon
                        //               // Adjust the width as needed
                        //               color: Colors
                        //                   .white, // Set the desired color for the icon
                        //             ),
                        //             SizedBox(width: 10),
                        //             Text(
                        //               "REGISTER WITH GOOGLE",
                        //               textAlign: TextAlign.center,
                        //               style: GoogleFonts.ubuntu(
                        //                   color: Colors.white, fontSize: 16),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),


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
                                  color: MyTheme.secondary,
                                  fontWeight: FontWeight.bold,
                                  // Add this line for underline
                                  fontSize: 16),
                            )),
                          ),
                        ),
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
