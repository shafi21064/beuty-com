import 'dart:convert';

import 'package:kirei/helpers/endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:kirei/data_model/order_detail_response.dart';
import 'package:kirei/data_model/order_item_response.dart';
import 'package:kirei/helpers/shared_value_helper.dart';

class OrderRepository {

  Future<dynamic> getOrderList(
      {page = 1, payment_status = "", delivery_status = ""}) async {
    String baseUrl = ENDP.PURCHASE_HISTORY;
    Uri url = Uri.parse(baseUrl);
    print("url: ${url.toString()}");
    print("token: ${access_token.$}");
    final response = await http.get(url, headers: {
      "Authorization": "Bearer ${access_token.$}",
      "App-Language": app_language.$,
    });

    print("Order His.res: ${response.body}");
    return jsonDecode(response.body);
  }

  Future<OrderDetailResponse> getOrderDetails({@required int id = 0}) async {
    Uri url = Uri.parse("${ENDP.PURCHASE_HISTORY_DETAILS}" + id.toString());

    final response = await http.get(url, headers: {
      "Authorization": "Bearer ${access_token.$}",
      "App-Language": app_language.$,
    });
    print(response.body);
    return orderDetailResponseFromJson(response.body);
  }

  Future<OrderItemResponse> getOrderItems({@required int id = 0}) async {
    Uri url = Uri.parse("${ENDP.PURCHASE_HISTORY_ITEM}" + id.toString());
    final response = await http.get(url, headers: {
      "Authorization": "Bearer ${access_token.$}",
      "App-Language": app_language.$,
    });

    print(url);
    print(response.body.toString());
    return orderItemlResponseFromJson(response.body);
  }

  Future<dynamic> getReOrder({@required int id = 0}) async {
    Uri url = Uri.parse("${ENDP.RE_ORDER}"+id.toString());

    final response = await http.get(url, headers: {
      "Authorization": "Bearer ${access_token.$}",
      "App-Language": app_language.$,
    });
    print("ReOrder Message: ${response.body}");
    //return orderDetailResponseFromJson(response.body);
    return jsonDecode(response.body);
  }
}
