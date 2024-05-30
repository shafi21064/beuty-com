class DeactivationResponse {
  bool result;
  String message;

  DeactivationResponse({this.result, this.message});

  factory DeactivationResponse.fromJson(Map<String, dynamic> json) {
    return DeactivationResponse(
      result: json['result'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
    };
  }
}
