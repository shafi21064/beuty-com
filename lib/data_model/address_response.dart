import 'dart:convert';

AddressResponse addressResponseFromJson(String str) =>
    AddressResponse.fromJson(json.decode(str));

String addressResponseToJson(AddressResponse data) =>
    json.encode(data.toJson());

class AddressResponse {
  AddressResponse({
    this.data,
    this.success,
    this.status,
  });

  List<Address> data;
  bool success;
  int status;

  factory AddressResponse.fromJson(Map<String, dynamic> json) =>
      AddressResponse(
        data: List<Address>.from(json["data"].map((x) => Address.fromJson(x))),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "success": success,
        "status": status,
      };
}

class Address {
  Address({
    this.id,
    this.user_id,
    this.address,
    this.country_id,
    this.country_name,
    this.city_id,
    this.city_name,
    this.zone_id,
    this.zone_name,
    this.area_id,
    this.area_name,
    this.postal_code,
    this.phone,
    this.set_default,
    this.location_available,
    this.lat,
    this.lang,
  });

  int id;
  int user_id;
  String address;
  int country_id;
  String country_name;
  int city_id;
  String city_name;
  int zone_id;
  String zone_name;
  int area_id;
  String area_name;
  String postal_code;
  String phone;
  int set_default;
  bool location_available;
  double lat;
  double lang;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        user_id: json["user_id"],
        address: json["address"],
        country_id: json["country_id"],
        country_name: json["country_name"],
        city_id: json["city_id"],
        city_name: json["city_name"],
        zone_id: json["zone_id"],
        zone_name: json["zone_name"],
        area_id: json["area_id"],
        area_name: json["area_name"],
        postal_code: json["postal_code"],
        phone: json["phone"],
        set_default: json["set_default"],
        location_available: json["location_available"],
        lat: json["lat"],
        lang: json["lang"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": user_id,
        "address": address,
        "country_id": country_id,
        "country_name": country_name,
        "city_id": city_id,
        "city_name": city_name,
        "zone_id": zone_id,
        "zone_name": zone_name,
        "area_id": area_id,
        "area_id": area_name,
        "postal_code": postal_code,
        "phone": phone,
        "set_default": set_default,
        "location_available": location_available,
        "lat": lat,
        "lang": lang,
      };
}
