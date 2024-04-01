import 'package:kirei/helpers/endpoints.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:kirei/data_model/address_add_response.dart';
import 'package:kirei/data_model/address_update_response.dart';
import 'package:kirei/data_model/address_update_location_response.dart';
import 'package:kirei/data_model/address_delete_response.dart';
import 'package:kirei/data_model/address_make_default_response.dart';
import 'package:kirei/data_model/address_update_in_cart_response.dart';
import 'package:kirei/data_model/city_response.dart';
import 'package:kirei/data_model/state_response.dart';
import 'package:kirei/data_model/country_response.dart';
import 'package:kirei/data_model/shipping_cost_response.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:flutter/foundation.dart';

class AddressRepository {

  Future<dynamic> getAddressList() async {
    Uri url = Uri.parse("${ENDP.AddrList}");
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );
    print("response.body.toString()${response.body.toString()}");
    return jsonDecode(response.body);

  }


  Future<AddressAddResponse> getAddressAddResponse(
      {@required String address,
      @required String area,
      @required String zone,
      @required String city,
      @required String postal_code,
      @required String phone,
      @required String name,
      @required String email,
      @required String note,
      }) async {
    var post_body = jsonEncode({
      "address": "$address",
      "area": "$area",
      "zone": "$zone",
      "city": "$city",
      "phone": "$phone",
      "name" : "$name",
      "email" : "$email",
      "note" : "$note"
    });
    print(post_body);

    Uri url = Uri.parse("${ENDP.AddAddr}");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$
        },
        body: post_body);

    print(url);
    print(response.body.toString());
    return addressAddResponseFromJson(response.body);
  }

  Future<AddressAddResponse> getAddressUpdateAddResponse(
      {@required String address,
        @required int area,
        @required int zone,
        @required int city,
        @required String phone,
        @required String name,
        @required String email,
        @required String note,
      }) async {
    var post_body = jsonEncode({
      "address": "$address",
      "area_id": area,
      "zone_id": zone,
      "city_id": city,
      "phone": "$phone",
      "name" : "$name",
      "email" : "$email",
      "note" : "$note"
    });
    print('my address data2' +post_body);

    Uri url = Uri.parse("${ENDP.UpdateAddrNew}");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$
        },
        body: post_body);

    print(url);
    print("initialState: "+response.body.toString());
    return addressAddResponseFromJson(response.body);
  }

  Future<AddressUpdateResponse> getAddressUpdateResponse(
      {@required int id,
      @required String address,
      @required int country_id,
      @required int state_id,
      @required int city_id,
      @required String postal_code,
      @required String phone}) async {
    var post_body = jsonEncode({
      "id": "${id}",
      "user_id": "${user_id.$}",
      "address": "$address",
      "country_id": "$country_id",
      "state_id": "$state_id",
      "city_id": "$city_id",
      "postal_code": "$postal_code",
      "phone": "$phone"
    });

    Uri url = Uri.parse("${ENDP.UpdateAddr}");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$
        },
        body: post_body);

    return addressUpdateResponseFromJson(response.body);
  }

  Future<AddressUpdateLocationResponse> getAddressUpdateLocationResponse(
    @required int id,
    @required double latitude,
    @required double longitude,
  ) async {
    var post_body = jsonEncode({
      "id": "${id}",
      "user_id": "${user_id.$}",
      "latitude": "$latitude",
      "longitude": "$longitude"
    });

    Uri url = Uri.parse("${ENDP.UpdateShipAddr}");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$
        },
        body: post_body);

    return addressUpdateLocationResponseFromJson(response.body);
  }

  Future<AddressMakeDefaultResponse> getAddressMakeDefaultResponse(
    @required int id,
  ) async {
    var post_body = jsonEncode({
      "id": "$id",
    });

    Uri url = Uri.parse("${ENDP.ShipDefault}");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}"
        },
        body: post_body);

print(response.body.toString());
    return addressMakeDefaultResponseFromJson(response.body);
  }

  Future<AddressDeleteResponse> getAddressDeleteResponse(
    @required int id,
  ) async {
    Uri url = Uri.parse("${ENDP.ShipDelete}/$id");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$
      },
    );

    return addressDeleteResponseFromJson(response.body);
  }

  Future<CityResponse> getZoneByCity({state_id = 0, name = ""}) async {
    Uri url = Uri.parse("${ENDP.AddrDelete}/${state_id}");
    final response = await http.get(url);

    print(url.toString());
    print("STATUSCODE ${response.statusCode.toString()}");
    print(response.body.toString());
    return cityResponseFromJson(response.body);
  }

  Future<MyStateResponse> getCityByCountry({country_id = 0}) async {
    Uri url = Uri.parse("${ENDP.StateList}/${country_id}");
    final response = await http.get(url);

    print(url);
    print(response.body.toString());
    return myStateResponseFromJson(response.body);
  }

  Future<CountryResponse> getAreaByZone({id}) async {
    Uri url = Uri.parse("${ENDP.CountryList}/${id}");
    final response = await http.get(url);

    print(url);
    print(response.body.toString());
    return countryResponseFromJson(response.body);
  }

  Future<ShippingCostResponse> getShippingCostResponse(
      {@required int user_id,
      int address_id = 0,
      int pick_up_id = 0,
      shipping_type = "home_delivery"}) async {
    var post_body = jsonEncode({
      "address_id": "$address_id",
      "pickup_point_id": "$pick_up_id",
      "shipping_type": "$shipping_type"
    });

    Uri url = Uri.parse("${ENDP.ShippingCost}");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$
        },
        body: post_body);

    return shippingCostResponseFromJson(response.body);
  }

  Future<AddressUpdateInCartResponse> getAddressUpdateInCartResponse(
      {int address_id = 0, int pickup_point_id = 0}) async {
    var post_body = jsonEncode({
      "address_id": "${address_id}",
      "pickup_point_id": "${pickup_point_id}",
      "user_id": "${user_id.$}"
    });

    Uri url = Uri.parse("${ENDP.AddrUpdateInCart}");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$
        },
        body: post_body);

    return addressUpdateInCartResponseFromJson(response.body);
  }
}
