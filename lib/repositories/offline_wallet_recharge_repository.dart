import 'dart:convert';
import 'package:kirei/app_config.dart';
import 'package:kirei/data_model/offline_wallet_recharge_response.dart';
import 'package:kirei/helpers/endpoints.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OfflineWalletRechargeRepository{
 Future<OfflineWalletRechargeResponse> getOfflineWalletRechargeResponse({@required String amount,
  @required String name,
  @required String trx_id,
  @required int photo})async{


    var post_body = jsonEncode({
      "amount": "$amount",
      "payment_option": "Offline Payment",
      "trx_id": "$trx_id",
      "photo": "$photo",
    });
    Uri url = Uri.parse("${ENDP.OFFLINE_RECHARGE}");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$
        },
        body: post_body);
     print("hello Offline wallet recharge" + response.body.toString());
     return offlineWalletRechargeResponseFromJson(response.body);
  }
}