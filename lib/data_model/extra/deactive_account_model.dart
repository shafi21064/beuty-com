import 'dart:convert';

class DeActiveAccountResponse {
  bool success;
  String message;

  DeActiveAccountResponse({
    this.success,
    this.message,
  });

  factory DeActiveAccountResponse.fromRawJson(String str) => DeActiveAccountResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DeActiveAccountResponse.fromJson(Map<String, dynamic> json) => DeActiveAccountResponse(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}
