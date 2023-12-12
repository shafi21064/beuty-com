// To parse this JSON data, do
//
//     final appointmentResponse = appointmentResponseFromJson(jsonString);

import 'dart:convert';

AppointmentResponse appointmentResponseFromJson(String str) =>
    AppointmentResponse.fromJson(json.decode(str));

String appointmentResponseToJson(AppointmentResponse data) =>
    json.encode(data.toJson());


class AppointmentResponse {


  AppointmentResponse({
     this.statusCode,
     this.statusMessage,
     this.paymentID,
     this.bkashURL,
     this.callbackURL,
     this.successCallbackURL,
     this.failureCallbackURL,
     this.cancelledCallbackURL,
     this.amount,
     this.intent,
     this.currency,
     this.paymentCreateTime,
     this.transactionStatus,
     this.merchantInvoiceNumber,
  });
  String statusCode;
  String statusMessage;
  String paymentID;
  String bkashURL;
  String callbackURL;
  String successCallbackURL;
  String failureCallbackURL;
  String cancelledCallbackURL;
  String amount;
  String intent;
  String currency;
  String paymentCreateTime;
  String transactionStatus;
  String merchantInvoiceNumber;

  factory AppointmentResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentResponse(
      statusCode: json['statusCode'],
      statusMessage: json['statusMessage'],
      paymentID: json['paymentID'],
      bkashURL: json['bkashURL'],
      callbackURL: json['callbackURL'],
      successCallbackURL: json['successCallbackURL'],
      failureCallbackURL: json['failureCallbackURL'],
      cancelledCallbackURL: json['cancelledCallbackURL'],
      amount: json['amount'],
      intent: json['intent'],
      currency: json['currency'],
      paymentCreateTime: json['paymentCreateTime'],
      transactionStatus: json['transactionStatus'],
      merchantInvoiceNumber: json['merchantInvoiceNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'statusMessage': statusMessage,
      'paymentID': paymentID,
      'bkashURL': bkashURL,
      'callbackURL': callbackURL,
      'successCallbackURL': successCallbackURL,
      'failureCallbackURL': failureCallbackURL,
      'cancelledCallbackURL': cancelledCallbackURL,
      'amount': amount,
      'intent': intent,
      'currency': currency,
      'paymentCreateTime': paymentCreateTime,
      'transactionStatus': transactionStatus,
      'merchantInvoiceNumber': merchantInvoiceNumber,
    };
  }
}
