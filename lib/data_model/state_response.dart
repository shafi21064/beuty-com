// To parse this JSON data, do
//
//     final MyStateResponse = myStateResponseFromJson(jsonString);

import 'dart:convert';

MyStateResponse myStateResponseFromJson(String str) =>
    MyStateResponse.fromJson(json.decode(str));

String myStateResponseToJson(MyStateResponse data) =>
    json.encode(data.toJson());

class MyStateResponse {
  MyStateResponse({
    this.states,
    this.success,
    this.status,
  });

  List<MyState> states;
  bool success;
  int status;

  factory MyStateResponse.fromJson(Map<String, dynamic> json) =>
      MyStateResponse(
        states: List<MyState>.from(
            json["data"]["states"].map((x) => MyState.fromJson(x))),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": {
          "states": List<dynamic>.from(states.map((x) => x.toJson())),
        },
        "success": success,
        "status": status,
      };
}

class MyState {
  MyState({
    this.id,
    this.name,
  });

  @override
  String toString() => '$name';

  int id;
  String name;

  factory MyState.fromJson(Map<String, dynamic> json) => MyState(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
