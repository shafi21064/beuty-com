import 'package:kirei/app_config.dart';
import 'package:kirei/data_model/profile_image_update_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:kirei/data_model/profile_counters_response.dart';
import 'package:kirei/data_model/profile_update_response.dart';
import 'package:kirei/data_model/device_token_update_response.dart';
import 'package:kirei/data_model/phone_email_availability_response.dart';

import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:flutter/foundation.dart';

class ProfileRepository {


  Future<ProfileCountersResponse> getProfileCountersResponse() async {

    Uri url = Uri.parse("${AppConfig.BASE_URL}/profile/counters");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}","App-Language": app_language.$,
      },
    );


    print(url);
    print(response.body.toString());
    return profileCountersResponseFromJson(response.body);
  }

  Future<ProfileUpdateResponse> getProfileUpdateResponse(
      @required String name,@required String password, @required String currentPassword) async {

    var post_body = jsonEncode({"name": "${name}", "password": "$password", "current_password" : "${currentPassword}"});

    Uri url = Uri.parse("${AppConfig.BASE_URL}/profile/update");
    final response = await http.post(url,
        headers: {"Content-Type": "application/json", "Authorization": "Bearer ${access_token.$}","App-Language": app_language.$,},body: post_body );

    //print(response.body.toString());
    return profileUpdateResponseFromJson(response.body);
  }

  Future<DeviceTokenUpdateResponse> getDeviceTokenUpdateResponse(
      @required String device_token) async {

    var post_body = jsonEncode({"device_token": "${device_token}"});

    Uri url = Uri.parse("${AppConfig.BASE_URL}/profile/update-device-token");
    final response = await http.post(url,
        headers: {"Content-Type": "application/json", "Authorization": "Bearer ${access_token.$}","App-Language": app_language.$,},body: post_body );

    print(response.body.toString());
    return deviceTokenUpdateResponseFromJson(response.body);
  }

  Future<ProfileImageUpdateResponse> getProfileImageUpdateResponse(
      @required String image,@required String filename) async {

    var post_body = jsonEncode({"image": "${image}", "filename": "$filename"});
    //print(post_body.toString());

    Uri url = Uri.parse("${AppConfig.BASE_URL}/profile/update-image");
    final response = await http.post(url,
        headers: {"Content-Type": "application/json", "Authorization": "Bearer ${access_token.$}","App-Language": app_language.$,},body: post_body );

    //print(response.body.toString());
    return profileImageUpdateResponseFromJson(response.body);
  }

  Future<PhoneEmailAvailabilityResponse> getPhoneEmailAvailabilityResponse() async {

    //var post_body = jsonEncode({"user_id":"${user_id.$}"});

    Uri url = Uri.parse("${AppConfig.BASE_URL}/profile/check-phone-and-email");
    final response = await http.post(url,
        headers: {"Authorization": "Bearer ${access_token.$}","App-Language": app_language.$,});

    print(response.body.toString());
    return phoneEmailAvailabilityResponseFromJson(response.body);
  }

}
