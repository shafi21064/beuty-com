import 'package:flutter/material.dart';
import 'package:kirei/app_config.dart';
import 'package:kirei/helpers/endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:kirei/data_model/cart_response.dart';
import 'package:kirei/data_model/cart_delete_response.dart';
import 'package:kirei/data_model/cart_process_response.dart';
import 'package:kirei/data_model/cart_add_response.dart';
import 'package:kirei/data_model/cart_summary_response.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:kirei/providers/version_change.dart';
import 'package:provider/provider.dart';

class CartRepository {
  Future<List<CartResponse>> getCartResponseList(
    @required int user_id,
      @required BuildContext context
  ) async {
    Uri url = Uri.parse("${ENDP.GET_CARTS}");
    var post_body = jsonEncode({
      "version": "${Provider.of<VersionChange>(context, listen: false).latestVersion}",
    });
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
      body: post_body,
    );
    print(url);
    print(response.body.toString());
    return cartResponseFromJson(response.body);
  }

  Future<CartDeleteResponse> getCartDeleteResponse(
    @required int cart_id,
  ) async {
    Uri url = Uri.parse("${ENDP.GET_CARTS}/$cart_id");
    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$
      },
    );

    return cartDeleteResponseFromJson(response.body);
  }

  Future<CartProcessResponse> getCartProcessResponse(
      @required String cart_ids, @required String cart_quantities) async {
    var post_body = jsonEncode(
        {"cart_ids": "${cart_ids}", "cart_quantities": "$cart_quantities"});
print(post_body);
    Uri url = Uri.parse("${ENDP.GET_PROCESS}");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$
        },
        body: post_body);

    print(url);
    print(response.body.toString());
    return cartProcessResponseFromJson(response.body);
  }

  Future<CartAddResponse> getCartAddResponse(
      @required int id,
      @required String variant,
      @required int user_id,
      @required int _quantity,
      @required dynamic preorderAvailable,
      @required dynamic requestAvailable,
  @required BuildContext context
      ) async {
        print(preorderAvailable);
    var post_body = jsonEncode({
      "id": "${id}",
      //"variant": "$variant",
      "user_id": "$user_id",
      "quantity": "$_quantity",
      "is_preorder": "$preorderAvailable",
      "is_request": "$requestAvailable",
      //"cost_matrix": AppConfig.purchase_code,
      "version": "${Provider.of<VersionChange>(context, listen: false).latestVersion}",
    });

    print(post_body);

    Uri url = Uri.parse("${ENDP.ADD_CART}");
    print(url);
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$
        },
        body: post_body);

    print(response.body.toString());
    return cartAddResponseFromJson(response.body);
  }

  Future<CartSummaryResponse> getCartSummaryResponse() async {
    Uri url = Uri.parse("${ENDP.CART_SUMMARY}");
    print(" cart summary");
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$
      },
    );
    print("access token ${access_token.$}");

    print("cart summary res ${response.body}");
    return cartSummaryResponseFromJson(response.body);
  }

  Future<dynamic> getCartQuantityResponse( productId, int ProductQuantity) async {
    Uri url = Uri.parse("${ENDP.CART_QUANTITY}");
    print("cart Change Quantity");

    var post_body = jsonEncode({
      "id": "${productId}",
      "quantity": "${ProductQuantity}",
    });

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$
      },
      body: post_body,
    );
    print("access token ${access_token.$}");

    print("cart Quantity res ${response.body}");
    
    return jsonDecode(response.body);
  }
}
