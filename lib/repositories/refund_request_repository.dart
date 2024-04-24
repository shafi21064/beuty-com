import 'package:kirei/app_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:kirei/data_model/refund_request_response.dart';
import 'package:kirei/data_model/refund_request_send_response.dart';

class RefundRequestRepository {

  Future<RefundRequestResponse> getRefundRequestListResponse({@required page = 1}) async {

    Uri url = Uri.parse("${AppConfig.BASE_URL}/refund-request/get-list");
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );


    print(url);
    print(response.body.toString());
    return refundRequestResponseFromJson(response.body);
  }

  Future<RefundRequestSendResponse> getRefundRequestSendResponse({@required int id,@required String reason}
      ) async {
    var post_body = jsonEncode({
      "id": "${id}",
      "reason": "${reason}",
    });

    Uri url = Uri.parse("${AppConfig.BASE_URL}/refund-request/send");
    final response =
    await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}","App-Language": app_language.$,
        },
        body: post_body);

    print(url);
    print(response.body.toString());
    return refundRequestSendResponseFromJson(response.body);
  }

}