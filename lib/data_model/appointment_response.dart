// To parse this JSON data, do
//
//     final appointmentResponse = appointmentResponseFromJson(jsonString);

import 'dart:convert';

AppointmentResponse appointmentResponseFromJson(String str) =>
    AppointmentResponse.fromJson(json.decode(str));

String appointmentResponseToJson(AppointmentResponse data) =>
    json.encode(data.toJson());


// class AppointmentResponse {
//
//
//   AppointmentResponse({
//      this.statusCode,
//      this.statusMessage,
//      this.paymentID,
//      this.bkashURL,
//      this.callbackURL,
//      this.successCallbackURL,
//      this.failureCallbackURL,
//      this.cancelledCallbackURL,
//      this.amount,
//      this.intent,
//      this.currency,
//      this.paymentCreateTime,
//      this.transactionStatus,
//      this.merchantInvoiceNumber,
//   });
//   String statusCode;
//   String statusMessage;
//   String paymentID;
//   String bkashURL;
//   String callbackURL;
//   String successCallbackURL;
//   String failureCallbackURL;
//   String cancelledCallbackURL;
//   String amount;
//   String intent;
//   String currency;
//   String paymentCreateTime;
//   String transactionStatus;
//   String merchantInvoiceNumber;
//
//   factory AppointmentResponse.fromJson(Map<String, dynamic> json) {
//     return AppointmentResponse(
//       statusCode: json['statusCode'],
//       statusMessage: json['statusMessage'],
//       paymentID: json['paymentID'],
//       bkashURL: json['bkashURL'],
//       callbackURL: json['callbackURL'],
//       successCallbackURL: json['successCallbackURL'],
//       failureCallbackURL: json['failureCallbackURL'],
//       cancelledCallbackURL: json['cancelledCallbackURL'],
//       amount: json['amount'],
//       intent: json['intent'],
//       currency: json['currency'],
//       paymentCreateTime: json['paymentCreateTime'],
//       transactionStatus: json['transactionStatus'],
//       merchantInvoiceNumber: json['merchantInvoiceNumber'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'statusCode': statusCode,
//       'statusMessage': statusMessage,
//       'paymentID': paymentID,
//       'bkashURL': bkashURL,
//       'callbackURL': callbackURL,
//       'successCallbackURL': successCallbackURL,
//       'failureCallbackURL': failureCallbackURL,
//       'cancelledCallbackURL': cancelledCallbackURL,
//       'amount': amount,
//       'intent': intent,
//       'currency': currency,
//       'paymentCreateTime': paymentCreateTime,
//       'transactionStatus': transactionStatus,
//       'merchantInvoiceNumber': merchantInvoiceNumber,
//     };
//   }
// }


class AppointmentResponse {
  bool result;
  Data data;
  String message;

  AppointmentResponse({this.result, this.data, this.message});

  AppointmentResponse.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  Appintment appintment;
  String paymentUrl;

  Data({this.appintment, this.paymentUrl});

  Data.fromJson(Map<String, dynamic> json) {
    appintment = json['appintment'] != null
        ? new Appintment.fromJson(json['appintment'])
        : null;
    paymentUrl = json['payment_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.appintment != null) {
      data['appintment'] = this.appintment.toJson();
    }
    data['payment_url'] = this.paymentUrl;
    return data;
  }
}

class Appintment {
  String name;
  String age;
  String contactNumber;
  String whatsappNumber;
  String problem;
  String paymentType;
  int paymentAmount;
  String status;
  String paymentStatus;
  Null availableDateId;
  Null doctorId;
  String updatedAt;
  String createdAt;
  int id;

  Appintment(
      {this.name,
        this.age,
        this.contactNumber,
        this.whatsappNumber,
        this.problem,
        this.paymentType,
        this.paymentAmount,
        this.status,
        this.paymentStatus,
        this.availableDateId,
        this.doctorId,
        this.updatedAt,
        this.createdAt,
        this.id});

  Appintment.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    age = json['age'];
    contactNumber = json['contact_number'];
    whatsappNumber = json['whatsapp_number'];
    problem = json['problem'];
    paymentType = json['payment_type'];
    paymentAmount = json['payment_amount'];
    status = json['status'];
    paymentStatus = json['payment_status'];
    availableDateId = json['available_date_id'];
    doctorId = json['doctor_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['age'] = this.age;
    data['contact_number'] = this.contactNumber;
    data['whatsapp_number'] = this.whatsappNumber;
    data['problem'] = this.problem;
    data['payment_type'] = this.paymentType;
    data['payment_amount'] = this.paymentAmount;
    data['status'] = this.status;
    data['payment_status'] = this.paymentStatus;
    data['available_date_id'] = this.availableDateId;
    data['doctor_id'] = this.doctorId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}