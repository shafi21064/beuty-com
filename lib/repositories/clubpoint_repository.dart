import 'package:kirei/helpers/endpoints.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:kirei/data_model/clubpoint_response.dart';
import 'package:kirei/data_model/clubpoint_to_wallet_response.dart';

class ClubpointRepository {
  Future<ClubpointResponse> getClubPointListResponse(
      {@required page = 1}) async {
    Uri url = Uri.parse(
        "${ENDP.CLUB_POINT}$page");
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$
      },
    );


    print(url);
    print(response.body.toString());

    return clubpointResponseFromJson(response.body);
  }

  Future<ClubpointToWalletResponse> getClubpointToWalletResponse(
      @required int id) async {
    var post_body = jsonEncode({
      "id": "${id}",
    });
    Uri url = Uri.parse("${ENDP.CLUB_POINT_WALLET}");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$
        },
        body: post_body);

    print(url);
    print(response.body.toString());
    return clubpointToWalletResponseFromJson(response.body);
  }
}
