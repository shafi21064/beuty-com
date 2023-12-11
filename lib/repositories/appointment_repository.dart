import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/helpers/endpoints.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class AppointmentRepository {
 Future<void> submitAppointment({
   @required String age,
    @required String contactNumber,
    @required String name,
    @required String paymentType,
    @required String problem,
    @required String whatsappNumber,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.BASE_URL_1}/new-appointment/store'),
        body: {
          'age': age,
          'contact_number': contactNumber,
          'name': name,
          'payment_type': paymentType,
          'problem': problem,
          'whatsapp_number': whatsappNumber,
        },
      );
      

      if (response.statusCode == 200) {
        print('Appointment submitted successfully');
      } else {
        print('Failed to submit appointment. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error submitting appointment: $e');
    }
  }
  }

