import 'package:kirei/app_config.dart';
import 'package:kirei/helpers/endpoints.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:kirei/data_model/conversation_response.dart';
import 'package:kirei/data_model/message_response.dart';
import 'package:kirei/data_model/conversation_create_response.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:flutter/foundation.dart';

class ChatRepository {
  Future<ConversationResponse> getConversationResponse(
      {@required page = 1}) async {
    Uri url = Uri.parse(
        "${ENDP.GET_CONVERSATION}${page}");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );
    return conversationResponseFromJson(response.body);
  }

  Future<MessageResponse> getMessageResponse(
      {@required conversation_id, @required page = 1}) async {
    Uri url = Uri.parse(
        "${ENDP.GET_MESSAGE+conversation_id}?page=${page}");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$
      },
    );
    return messageResponseFromJson(response.body);
  }

  Future<MessageResponse> getInserMessageResponse(
      {@required conversation_id, @required String message}) async {
    var post_body = jsonEncode({
      "user_id": "${user_id.$}",
      "conversation_id": "${conversation_id}",
      "message": "${message}"
    });

    Uri url = Uri.parse("${ENDP.INSERT_MESSAGE}");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$
        },
        body: post_body);
    return messageResponseFromJson(response.body);
  }

  Future<MessageResponse> getNewMessageResponse(
      {@required conversation_id, @required last_message_id}) async {
    Uri url = Uri.parse(
        "${ENDP.NEW_MESSAGE+conversation_id}/${last_message_id}");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$
      },
    );
    /* print("${AppConfig.BASE_URL}/chat/get-new-messages/${conversation_id}/${last_message_id}");
    print(response.body.toString());*/
    return messageResponseFromJson(response.body);
  }

  Future<ConversationCreateResponse> getCreateConversationResponse(
      {@required product_id,
      @required String title,
      @required String message}) async {
    var post_body = jsonEncode({
      "user_id": "${user_id.$}",
      "product_id": "${product_id}",
      "title": "${title}",
      "message": "${message}"
    });

    Uri url = Uri.parse("${ENDP.CREATE_CONVERSATION}");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.$}",
          "App-Language": app_language.$
        },
        body: post_body);
    return conversationCreateResponseFromJson(response.body);
  }
}
