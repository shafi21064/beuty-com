import 'dart:convert';

import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/appointment_response.dart';
import 'package:active_ecommerce_flutter/helpers/endpoints.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class AppointmentRepository {
  Future<AppointmentResponse> submitAppointment({
    @required String age,
    @required String contactNumber,
    @required String name,
    @required String paymentType,
    @required String problem,
    @required String whatsappNumber,
  }) async {
    var post_body = jsonEncode({
      'age': age,
      'contact_number': contactNumber,
      'name': name,
      'payment_type': paymentType,
      'problem': problem,
      'whatsapp_number': whatsappNumber,
    });
    final response = await http.post(
        Uri.parse('${AppConfig.BASE_URL_1}/new-appointment/store'),
        headers: {
          "Accept": "*/*",
          "Content-Type": "application/json",
          "App-Language": app_language.$,
        },
        body: post_body);

    return appointmentResponseFromJson(response.body.toString());
  }
}
