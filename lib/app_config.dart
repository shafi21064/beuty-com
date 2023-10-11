import 'package:flutter/material.dart';

var this_year = DateTime.now().year.toString();

class AppConfig {
  static String copyright_text =
      "@ Kireibd " + this_year; //this shows in the splash screen
  static String app_name = "Online Shop"; //this shows in the splash screen
  static String purchase_code =
      "bkash"; //enter your purchase code for the app from codecanyon
  //static String purchase_code = ""; //enter your purchase code for the app from codecanyon

  //Default language config
  static String default_language = "en";
  static String mobile_app_code = "en";
  static bool app_language_rtl = false;

  //configure this
  static const bool HTTPS = true;

  //configure this
  // static const DOMAIN_PATH = "192.168.1.112/ecommerce"; //localhost
  static const DOMAIN_PATH_1 = "app.kireibd.com"; //inside a folder
  //static const DOMAIN_PATH = "app.kireibd.com"; //inside a folder
  //static const DOMAIN_PATH = "mydomain.com"; // directly inside the public folder

  //static const DOMAIN_PATH = "demo.activeitzone.com/ecommerce_flutter_demo"; //inside a folder
  static const DOMAIN_PATH = "app.kireibd.com"; //inside a folder

  //do not configure these below
  static const String API_ENDPATH = "api/v2";
  //do not configure these below
  static const String API_ENDPATH_1 = "api/v2";
  static const String PROTOCOL = HTTPS ? "https://" : "http://";
  static const String RAW_BASE_URL = "${PROTOCOL}${DOMAIN_PATH}";
  static const String RAW_BASE_URL_1 = "${PROTOCOL}${DOMAIN_PATH_1}";
  static const String BASE_URL = "${RAW_BASE_URL}/${API_ENDPATH}";
  static const String BASE_URL_1 = "${RAW_BASE_URL_1}/${API_ENDPATH_1}";
}
