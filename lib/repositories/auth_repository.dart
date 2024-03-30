import 'package:kirei/app_config.dart';
import 'package:kirei/data_model/cart_add_response.dart';
import 'package:kirei/helpers/endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:kirei/data_model/login_response.dart';
import 'package:kirei/data_model/logout_response.dart';
import 'package:kirei/data_model/signup_response.dart';
import 'package:kirei/data_model/resend_code_response.dart';
import 'package:kirei/data_model/confirm_code_response.dart';
import 'package:kirei/data_model/password_forget_response.dart';
import 'package:kirei/data_model/password_confirm_response.dart';
import 'package:kirei/data_model/user_by_token.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:kirei/helpers/shared_value_helper.dart';

class AuthRepository {
  // Future<LoginResponse> getLoginResponse(
  //     @required String email, @required String password) async {
  //   var post_body = jsonEncode({
  //     "email": "${email}",
  //     "password": "$password",
  //     "identity_matrix": AppConfig.purchase_code
  //   });

  //   Uri url = Uri.parse("${ENDP.LOGIN}");
  //   final response = await http.post(url,
  //       headers: {
  //         "Accept": "*/*",
  //         "Content-Type": "application/json",
  //         "App-Language": app_language.$,
  //       },
  //       body: post_body);
  //   print(post_body);
  //   return loginResponseFromJson(response.body);
  // }

  Future<LoginResponse> getLoginResponse(@required String email,
      @required String password, @required bool remember_me) async {
    var post_body = jsonEncode({
      "email": "${email}",
      "password": "$password",
      "remember_me": remember_me,
      "version": "2.0.7",
    });

    Uri url = Uri.parse("${ENDP.LOGIN}");
    final response = await http.post(url,
        headers: {
          "Accept": "*/*",
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);
    print(response.body.toString());
    return loginResponseFromJson(response.body);
  }

  Future<LoginResponse> getLoginOTPResponse(@required String phone) async {
    var post_body = jsonEncode({"email": "${phone}",
      "version": "2.0.7",
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/send-login-otp");
    final response = await http.post(url,
        headers: {
          "Accept": "*/*",
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);
    print(response.body);
    print("Logininfo"+response.body);
    print(response.body);
    return loginResponseFromJson(response.body);
  }

  Future<LoginResponse> getSocialLoginResponse(@required String social_provider,
      @required String name, @required String email, @required String provider,
      {access_token = ""}) async {
    email = email == ("null") ? "" : email;

    var post_body = jsonEncode({
      "name": "${name}",
      "email": email,
      "provider": "$provider",
      "social_provider": "$social_provider",
      "access_token": "$access_token"
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/social-login");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);
    print(post_body);
    print("post_body"+post_body);
    print(response.body.toString());
    print("post_body1"+response.body.toString());
    return loginResponseFromJson(response.body);
  }

  Future<LogoutResponse> getLogoutResponse() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/logout");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );

    print(response.body);

    return logoutResponseFromJson(response.body);
  }

  Future<SignupResponse> getSignupResponse(
      @required String name,
      @required String email_or_phone,
      @required String password,
      @required String passowrd_confirmation,
      @required String register_by) async {
    var post_body = jsonEncode({
      "name": "$name",
      "email_or_phone": "${email_or_phone}",
      "password": "$password",
      "password_confirmation": "${passowrd_confirmation}",
      "register_by": "$register_by",
      "version": "2.0.7",
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/signup");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);
    print(response.body);

    return signupResponseFromJson(response.body);
  }

  Future<SignupResponse> getSignupOtpResponse(
    @required String phone,
  ) async {
    var post_body = jsonEncode({
      "email": "${phone}",
      "version": "2.0.7",
    });
    print(post_body);
    Uri url = Uri.parse("${AppConfig.BASE_URL}/send-signup-otp");
    print(url);
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);
    print(response.body);
    return signupResponseFromJson(response.body);
  }

  // Future<ResendCodeResponse> getResendCodeResponse(
  //     @required int user_id, @required String verify_by) async {
  //   var post_body =
  //       jsonEncode({"user_id": "$user_id", "register_by": "$verify_by"});
  //
  //   Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/resend_code");
  //   final response = await http.post(url,
  //       headers: {
  //         "Content-Type": "application/json",
  //         "App-Language": app_language.$,
  //       },
  //       body: post_body);
  //
  //   return resendCodeResponseFromJson(response.body);
  // }

  Future<ResendCodeResponse> getResendCodeResponse(
      @required int phone) async {
    var post_body =
    jsonEncode({"email": phone,});

    //Uri url = Uri.parse("${AppConfig.BASE_URL}/send-reset-otp");
    Uri url = Uri.parse("${AppConfig.BASE_URL}/send-login-otp");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);

    return resendCodeResponseFromJson(response.body);
  }

  Future<ConfirmCodeResponse> getConfirmCodeResponse(
      @required int user_id, @required String verification_code) async {
    var post_body = jsonEncode(
        {"user_id": "$user_id", "verification_code": "$verification_code"});

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/confirm_code");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);

    return confirmCodeResponseFromJson(response.body);
  }

  Future<SignupResponse> getSignUpOtpConfirmCodeResponse(
      @required String phone, @required String verification_code) async {
    var post_body =
        jsonEncode({"email": "$phone", "otp_code": "$verification_code"});

    Uri url = Uri.parse("${AppConfig.BASE_URL}/verify-signup-otp");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);
    print(response.body);
    return signupResponseFromJson(response.body);
  }

  Future<LoginResponse> getLogInOtpConfirmCodeResponse(
      @required String phone, @required String verification_code) async {
    var post_body =
        jsonEncode({"email": "$phone", "otp_code": "$verification_code"});

    Uri url = Uri.parse("${AppConfig.BASE_URL}/verify-login-otp");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);
    print(response.body);
    return loginResponseFromJson(response.body);
  }

  Future<PasswordForgetResponse> getPasswordForgetResponse(
      @required String email_or_phone) async {
    var post_body = jsonEncode({"email": "$email_or_phone"});

    print(post_body);
    Uri url = Uri.parse(
      "${AppConfig.BASE_URL}/send-reset-otp",
    );
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);

    print(response.body.toString());

    return passwordForgetResponseFromJson(response.body);
  }

  Future<PasswordConfirmResponse> getPasswordConfirmResponse(
      @required String verification_code, @required String phone) async {
    var post_body =
        jsonEncode({"otp_code": "$verification_code", "email": "$phone"});
    print(post_body);

    Uri url = Uri.parse(
      "${AppConfig.BASE_URL}/verify-reset-otp",
    );
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);

    print(response.body.toString());

    return passwordConfirmResponseFromJson(response.body);
  }

  Future<CartAddResponse> getConfirmReset(
      @required String verification_code,
      @required String phone,
      @required bool otp_reset,
      @required String password) async {
    var post_body = jsonEncode({
      "otp_code": "$verification_code",
      "email": "$phone",
      "otp_reset": "$otp_reset",
      "password": "$password"
    });
    print(post_body);

    Uri url = Uri.parse(
      "${AppConfig.BASE_URL}/auth/password/confirm_reset",
    );
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);

    print(response.body.toString());

    return cartAddResponseFromJson(response.body);
  }

  Future<ResendCodeResponse> getPasswordResendCodeResponse(
      @required String email_or_code, @required String verify_by) async {
    var post_body = jsonEncode(
        {"email_or_code": "$email_or_code", "verify_by": "$verify_by"});

    Uri url = Uri.parse("${AppConfig.BASE_URL}/auth/password/resend_code");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);

    return resendCodeResponseFromJson(response.body);
  }

  Future<UserByTokenResponse> getUserByTokenResponse() async {
    var post_body = jsonEncode({"access_token": "${access_token.$}"});
    Uri url = Uri.parse("${AppConfig.BASE_URL}/get-user-by-access_token");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);

    return userByTokenResponseFromJson(response.body);
  }
}
