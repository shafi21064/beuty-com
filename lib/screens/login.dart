import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kirei/data_model/login_response.dart';
import 'package:kirei/my_theme.dart';
import 'package:kirei/other_config.dart';
import 'package:kirei/repositories/profile_repository.dart';
import 'package:kirei/screens/otp.dart';
import 'package:kirei/ui_sections/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kirei/custom/input_decorations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:kirei/screens/registration.dart';
import 'package:kirei/screens/main.dart';
import 'package:kirei/screens/password_forget.dart';
import 'package:kirei/custom/toast_component.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:toast/toast.dart';
import 'package:kirei/repositories/auth_repository.dart';
import 'package:kirei/helpers/auth_helper.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // String _login_by = "email"; //phone or email
  String _login_by = "otp";
  String initialCountry = 'BD';
  PhoneNumber phoneCode = PhoneNumber(isoCode: 'BD', dialCode: "+880");
  String _phone = "";
  bool validPhoneNumber = false;
  bool rememberMe = false;
  bool isLoading = false;

  //controllers
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    //on Splash Screen hide statusbar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  void dispose() {
    //before going to other screen show statusbar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  onPressedLogin() async {
    var email = _emailController.text.toString();
    var password = _passwordController.text.toString();
    var _phone = _phoneNumberController.text.toString();
    print("_phone${_phone}");

    if (_login_by == 'email' && email == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context).login_screen_email_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    } else if (_login_by == 'phone' && _phone == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context).login_screen_phone_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    } else if (_login_by == 'phone' && password == "") {
      ToastComponent.showDialog(
          AppLocalizations.of(context).login_screen_password_warning, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      return;
    } else if (_login_by == 'otp' && validPhoneNumber) {
      var loginResponse =
          await AuthRepository().getLoginOTPResponse(_phone, context);
      if (loginResponse.result == false) {
        ToastComponent.showDialog(loginResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      } else {
        ToastComponent.showDialog(loginResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

        // push notification starts

        //push norification end
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Otp(
            verify_by: _login_by,
            phoneNumber: loginResponse.phone,
            responseData: loginResponse,
            prev_screen: "Login",
            // user_id: signupResponse.user_id,01865284103
          );
        }));
      }
      return;
    }

    var loginResponse = await AuthRepository().getLoginResponse(
        _login_by == 'email' ? email : _phone, password, rememberMe, context);
    if (loginResponse.result == false) {
      ToastComponent.showDialog(loginResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    } else {
      ToastComponent.showDialog(loginResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      AuthHelper().setUserData(loginResponse);
      AuthHelper().fetch_and_set();
      // push notification starts

      //push norification ends

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Main();
      }));
    }
  }

  // Future<void> _loginWithFacebook() async {
  //   final result = await FacebookAuth.logIn(['email']);
  //   switch (result.status) {
  //     case FacebookLoginStatus.loggedIn:
  //     // You're logged in with Facebook, use result.accessToken to make API calls.
  //       break;
  //     case FacebookLoginStatus.cancelledByUser:
  //     // User cancelled the login.
  //       break;
  //     case FacebookLoginStatus.error:
  //     // There was an error during login.
  //       break;
  //   }
  // }

  signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();
    LoginResponse loginResponse;
    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken;
      final userData = await FacebookAuth.instance.getUserData();

      print('this is our facebook response ${userData}');

      loginResponse = await AuthRepository().getSocialLoginResponse(
          "facebook",
          userData["name"].toString(),
          userData["email"].toString(),
          userData["id"].toString(),
          access_token: accessToken.token);

      debugPrint('this is login response $loginResponse');

      if (loginResponse.result == false) {
        setState(() {
          isLoading = false;
        });
        ToastComponent.showDialog(loginResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

      } else {
        setState(() {
          isLoading = false;
        });
        ToastComponent.showDialog(loginResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        AuthHelper().setUserData(loginResponse);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Main();
        }));
      }

    } else {
      print(result.status);
      print(result.message);
    }


  }

  // onPressedFacebookLogin() async {
  //   final facebookLogin =
  //       await FacebookAuth.instance.login();
  //
  //   final OAuthCredential facebookCredential =  FacebookAuthProvider.credential(facebookLogin.accessToken.token);
  //
  //  FirebaseAuth.instance.signInWithCredential(facebookCredential);
  //
  //
  //   if (facebookLogin.status == 'success') {
  //     // get the user data
  //     // by default we get the userId, email,name and picture
  //     final userData = await FacebookAuth.instance.getUserData();
  //     var loginResponse = await AuthRepository().getSocialLoginResponse(
  //         "facebook",
  //         userData['name'].toString(),
  //         userData['email'].toString(),
  //         userData['id'].toString(),
  //         access_token: facebookLogin.accessToken.token);
  //     print("..........................${loginResponse.toString()}");
  //     if (loginResponse.result == false) {
  //       ToastComponent.showDialog(loginResponse.message, context,
  //           gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
  //     } else {
  //       ToastComponent.showDialog(loginResponse.message, context,
  //           gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
  //       AuthHelper().setUserData(loginResponse);
  //       Navigator.push(context, MaterialPageRoute(builder: (context) {
  //         return Main();
  //       }));
  //       FacebookAuth.instance.logOut();
  //     }
  //     // final userData = await FacebookAuth.instance.getUserData(fields: "email,birthday,friends,gender,link");
  //
  //   } else {
  //     print("....Facebook auth Failed.........");
  //     print(facebookLogin.status);
  //     print(facebookLogin.message);
  //   }
  // }

  onPressedGoogleLogin() async {
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

      final GoogleSignInAuthentication googleAuth =
          await googleUser?.authentication;

      setState(() {
        isLoading = true;
      });

      // final credential = GoogleAuthProvider.credential(
      //   accessToken: googleAuth?.accessToken,
      //   idToken: googleAuth?.idToken,
      // );

      var loginResponse = await AuthRepository().getSocialLoginResponse(
          "google", googleUser.displayName, googleUser.email, googleUser.id,
          access_token: googleAuth.accessToken);

      if (loginResponse.result == false) {
        setState(() {
          isLoading = false;
        });
        ToastComponent.showDialog(loginResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);

      } else {
        setState(() {
          isLoading = false;
        });
        ToastComponent.showDialog(loginResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        AuthHelper().setUserData(loginResponse);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Main();
        }));
      }
      GoogleSignIn().disconnect();
    } on Exception catch (e) {
      setState(() {
        isLoading = false;
      });
      print("error is ....... $e");
      // TODO
    }
  }

  onPressedTwitterLogin() async {
    // try {
    //   final twitterLogin = new TwitterLogin(
    //       apiKey: SocialConfig().twitter_consumer_key,
    //       apiSecretKey: SocialConfig().twitter_consumer_secret,
    //       redirectURI: 'activeecommerceflutterapp://');
    //   // Trigger the sign-in flow
    //   final authResult = await twitterLogin.login();

    //   var loginResponse = await AuthRepository().getSocialLoginResponse(
    //       "twitter",
    //       authResult.user.name,
    //       authResult.user.email,
    //       authResult.user.id.toString(),
    //       access_token: authResult.authToken);
    //   print(loginResponse);
    //   if (loginResponse.result == false) {
    //     ToastComponent.showDialog(loginResponse.message, context,
    //         gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    //   } else {
    //     ToastComponent.showDialog(loginResponse.message, context,
    //         gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    //     AuthHelper().setUserData(loginResponse);
    //     Navigator.push(context, MaterialPageRoute(builder: (context) {
    //       return Main();
    //     }));
    //   }
    // } on Exception catch (e) {
    //   print("error is ....... $e");
    //   // TODO
    // }
  }
///////////////////////// Apple Log In /////////////////////////////////////////
  Future<UserCredential> onPressAppleLogin() async {
    print('apple');
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        // webAuthenticationOptions: WebAuthenticationOptions(
        //   clientId: '6502335026', // Replace with your Client ID
        //   redirectUri: Uri.parse(
        //     'https://com.thetork.kirei.firebaseapp.com/__/auth/handler', // Replace with your redirect URI
        //   ),
        // ),
        nonce: nonce,
      );


      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );



      var loginResponse = await AuthRepository().getSocialLoginResponse(
          "apple", appleCredential.givenName, appleCredential.email, appleCredential.authorizationCode,
          access_token: appleCredential.identityToken);

      if (loginResponse.result == false) {
        ToastComponent.showDialog(loginResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      } else if(loginResponse.result == true) {
        ToastComponent.showDialog(loginResponse.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
        AuthHelper().setUserData(loginResponse);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return Main();
        }));
      }
      // GoogleSignIn().disconnect();

      final userCredential = await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      return userCredential;
    } catch (e) {
      print("Error during Apple Sign-In: $e");
      throw e;
    }
  }

  String generateNonce([int length = 32]) {
    final charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }


  @override
  Widget build(BuildContext context) {
    final _screen_height = MediaQuery.of(context).size.height;
    final _screen_width = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: MainDrawer(),
        body: isLoading? Center(child: CircularProgressIndicator()) : Stack(
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
                    child: Text("Login",
                        style: GoogleFonts.ubuntu(
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme
                                .primary,
                            fontSize: 18,
                            fontWeight: FontWeight.w600)),
                  ),
                  Container(
                    width: _screen_width * (3 / 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_login_by == "email")
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  height: 56,
                                  child: TextField(
                                    controller: _emailController,
                                    autofocus: false,
                                    autocorrect: true,
                                    decoration: InputDecoration(
                                      hintText: 'Enter Your Email Here...',
                                      prefixIcon: _login_by == "email"
                                          ? Icon(Icons.email)
                                          : Icon(Icons.local_phone_outlined),
                                      hintStyle: TextStyle(color: Colors.grey),
                                      filled: true,
                                      fillColor: Colors.white70,
                                    ),
                                  ),
                                ),
                                otp_addon_installed.$
                                    ? GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _login_by = "phone";
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Icon(
                                              Icons.phone_android_rounded,
                                              size: 18,
                                            ),
                                            Text(
                                              "Use Phone",
                                              style: GoogleFonts.ubuntu(
                                                  color: Colors.grey,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          )
                        else
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 4.0, top: 10),
                            child: Text("Phone",
                                style: GoogleFonts.ubuntu(
                                    color: Theme.of(context)
                                        .buttonTheme
                                        .colorScheme
                                        .primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                //padding: EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.only(bottom: 4.0),
                                height: 36,
                                // child: CustomInternationalPhoneNumberInput(
                                //   onInputChanged: (PhoneNumber number) {
                                //     print(number.phoneNumber);
                                //     setState(() {
                                //       _phone = number.phoneNumber;
                                //     });
                                //   },
                                //   onInputValidated: (bool value) {
                                //     if (value) {
                                //       validPhoneNumber = true;
                                //     } else {
                                //       _phone = '';
                                //     }
                                //   },
                                //   selectorConfig: SelectorConfig(
                                //     showFlags: false,
                                //     selectorType:
                                //         PhoneInputSelectorType.DROPDOWN,
                                //
                                //   ),
                                //
                                //   ignoreBlank: false,
                                //   autoValidateMode: AutovalidateMode.disabled,
                                //   selectorTextStyle:
                                //       TextStyle(color: MyTheme.secondary),
                                //   textStyle:
                                //       TextStyle(color: MyTheme.secondary),
                                //   initialValue: phoneCode,
                                //   //initialValue: null,
                                //   textFieldController: _phoneNumberController,
                                //   formatInput: true,
                                //   keyboardType:
                                //       TextInputType.numberWithOptions(
                                //           signed: true, decimal: true),
                                //   inputDecoration: InputDecorations
                                //       .buildInputDecoration_phone(
                                //           hint_text: "01*********"),
                                //   // inputBorder: OutlineInputBorder( // Customize the input border
                                //   //   borderRadius: BorderRadius.zero,
                                //   //   borderSide: BorderSide(color: Colors.black), // Customize the border color
                                //   // ),
                                //   onSaved: (PhoneNumber number) {
                                //     print('On Saved: $number');
                                //   },
                                //   countries: ["BD"],
                                // ),
                                child: Container(
                                  height: 56,
                                  child: TextField(
                                    controller: _phoneNumberController,
                                    onChanged: (number) {
                                      _phone = "${number}";
                                      validPhoneNumber = true;
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
                          visible: _login_by == "phone",
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 4.0, top: 10),
                            child: Text(
                                AppLocalizations.of(context)
                                    .login_screen_password,
                                style: GoogleFonts.ubuntu(
                                    color: Theme.of(context)
                                        .buttonTheme
                                        .colorScheme
                                        .primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Visibility(
                                visible: _login_by == "phone",
                                child: Container(
                                  height: 36,
                                  child: TextField(
                                    controller: _passwordController,
                                    autofocus: false,
                                    obscureText: true,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    decoration:
                                        InputDecorations.buildInputDecoration_1(
                                            hint_text: "• • • • • • • •"),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _login_by == "phone",
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: rememberMe,
                                          activeColor: Colors.black,
                                          onChanged: (value) {
                                            setState(() {
                                              rememberMe = !rememberMe;
                                            });
                                          },
                                        ),
                                        Text(
                                          "Remember Me",
                                          style: TextStyle(
                                            color: MyTheme.primary,
                                            //fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    // Add a spacer to push the next widget to the right
                                    // GestureDetector(
                                    //   onTap: () {
                                    //     Navigator.push(context,
                                    //         MaterialPageRoute(
                                    //             builder: (context) {
                                    //       return PasswordForget();
                                    //     }));
                                    //   },
                                    //   child: Text(
                                    //     AppLocalizations.of(context)
                                    //         .login_screen_forgot_password,
                                    //     style: TextStyle(
                                    //       color: MyTheme.primary,
                                    //       //fontStyle: FontStyle.italic,
                                    //       decoration: TextDecoration.underline,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          //padding: const EdgeInsets.all(8.0),
                          padding: EdgeInsets.only(
                              top: 8.0, left: 0, right: 0, bottom: 8),
                          child: RaisedButton(
                            onPressed: onPressedLogin,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2.0)),
                            padding: EdgeInsets.all(0.0),
                            child: Ink(
                              decoration:
                                  BoxDecoration(color: MyTheme.dark_grey),
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: 300.0, minHeight: 50.0),
                                alignment: Alignment.center,
                                child: Text(
                                  _login_by == "otp" ? "SEND OTP" : "LOGIN",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.openSans(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Center(
                              child: Text(
                            "Or, login with",
                            style: TextStyle(
                                color: MyTheme.dark_grey, fontSize: 12),
                          )),
                        ),
                        Padding(
                          //padding: const EdgeInsets.all(8.0),
                          padding: EdgeInsets.only(
                              top: 8.0, left: 0, right: 0, bottom: 8),
                          child: _login_by != "otp"
                              ? RaisedButton(
                                  onPressed: () {
                                    setState(() {
                                      _login_by = "otp";
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
                                        "LOGIN WITH OTP !",
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
                                      _login_by = "phone";
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2.0)),
                                  padding: EdgeInsets.all(0.0),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                        color: MyTheme.sign_up_with_password),
                                    child: Container(
                                      constraints: BoxConstraints(
                                          maxWidth: 300.0, minHeight: 50.0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        "LOGIN WITH PASSWORD !",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.ubuntu(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 8.0,
                            bottom: 8.0,
                            right: 0.0,
                            left: 0.0,
                          ),
                          child: RaisedButton(
                            onPressed: () {
                              signInWithFacebook();
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                            padding: EdgeInsets.all(0.0),
                            child: Ink(
                              decoration:
                                  BoxDecoration(color: MyTheme.facebook_bg),
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: 300.0, minHeight: 50.0),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.facebook_outlined,
                                      // You can replace this with the Google Icon
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "LOGIN WITH FACEBOOK",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.ubuntu(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 8.0,
                            bottom: 8.0,
                            right: 0.0,
                            left: 0.0,
                          ),
                          child: RaisedButton(
                            onPressed: onPressedGoogleLogin,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                            padding: EdgeInsets.all(0.0),
                            child: Ink(
                              decoration:
                                  BoxDecoration(color: MyTheme.google_bg),
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: 300.0, minHeight: 50.0),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/icon_google.png',
                                      // Replace with the actual path to your Google icon
                                      // Adjust the width as needed
                                      color: Colors
                                          .white, // Set the desired color for the icon
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "LOGIN WITH GOOGLE",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.ubuntu(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          //visible: !Platform.isAndroid,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              bottom: 8.0,
                              right: 0.0,
                              left: 0.0,
                            ),
                            child: RaisedButton(
                              onPressed: (){
                                onPressAppleLogin();
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                              padding: EdgeInsets.all(0.0),
                              child: Ink(
                                decoration:
                                BoxDecoration(color: MyTheme.apple_bg),
                                child: Container(
                                  height: 50,
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/apple-logo.png',

                                        // Replace with the actual path to your Google icon
                                        // Adjust the width as needed
                                        color: Colors
                                            .white, // Set the desired color for the icon
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "LOGIN WITH APPLE",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.ubuntu(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return Registration();
                            }));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Center(
                                child: Text(
                              "Don't have an account?",
                              style: TextStyle(
                                  color: MyTheme.secondary,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  // Add this line for underline
                                  fontSize: 16),
                            )),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return PasswordForget();
                              }));
                            },
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)
                                    .login_screen_forgot_password,
                                style: TextStyle(
                                    color: MyTheme.primary,
                                    //fontStyle: FontStyle.italic,
                                    decoration: TextDecoration.underline,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible:
                              allow_google_login.$ || allow_facebook_login.$,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Center(
                                child: Text(
                              AppLocalizations.of(context)
                                  .login_screen_login_with,
                              style: TextStyle(
                                  color: MyTheme.dark_grey, fontSize: 14),
                            )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Center(
                            child: Container(
                              width: 120,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Visibility(
                                    visible: allow_google_login.$,
                                    child: InkWell(
                                      onTap: () {
                                        onPressedGoogleLogin();
                                      },
                                      child: Container(
                                        width: 28,
                                        child: Image.asset(
                                            "assets/google_logo.png"),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: allow_facebook_login.$,
                                    child: InkWell(
                                      onTap: () {
                                        //onPressedFacebookLogin();
                                      },
                                      child: Container(
                                        width: 28,
                                        child: Image.asset(
                                            "assets/facebook_logo.png"),
                                      ),
                                    ),
                                  ),
                                  // SignInWithAppleButton(
                                  //   onPressed: () async {
                                  //     final credential = await SignInWithApple
                                  //         .getAppleIDCredential(
                                  //       scopes: [
                                  //         AppleIDAuthorizationScopes.email,
                                  //         AppleIDAuthorizationScopes.fullName,
                                  //       ],
                                  //     );
                                  //
                                  //     print(credential);
                                  //
                                  //     // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
                                  //     // after they have been validated with Apple (see `Integration` section for more information on how to do this)
                                  //   },
                                  // ),
                                  Visibility(
                                    visible: allow_twitter_login.$,
                                    child: InkWell(
                                      onTap: () {
                                        onPressedTwitterLogin();
                                      },
                                      child: Container(
                                        width: 28,
                                        child: Image.asset(
                                            "assets/twitter_logo.png"),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
