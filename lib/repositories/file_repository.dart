import 'package:kirei/helpers/endpoints.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:kirei/data_model/simple_image_upload_response.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:flutter/foundation.dart';

class FileRepository {
  Future<SimpleImageUploadResponse> getSimpleImageUploadResponse(
      @required String image, @required String filename) async {
    var post_body = jsonEncode({"image": "${image}", "filename": "$filename"});

    Uri url = Uri.parse("${ENDP.IMAGE_UPLOAD}");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$
        },
        body: post_body);

    return simpleImageUploadResponseFromJson(response.body);
  }
}
