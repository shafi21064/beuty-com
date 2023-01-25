import 'dart:convert';

import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/extra/BlogPostResponse.dart';
import 'package:active_ecommerce_flutter/data_model/extra/CommunityCommentResponse.dart';
import 'package:active_ecommerce_flutter/data_model/extra/NewCommunityPostResponse.dart';
import 'package:active_ecommerce_flutter/data_model/extra/addCommunityComment.dart';
import 'package:active_ecommerce_flutter/data_model/extra/addCommunityLike.dart';
import 'package:active_ecommerce_flutter/data_model/extra_community_HashTags_response.dart';
import 'package:active_ecommerce_flutter/data_model/extra_community_response.dart';
import 'package:active_ecommerce_flutter/helpers/endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';

class ExtraRepository {

  //Community View- Posts
  Future<BlogPostResponse> getBlogPosts() async {
    Uri url = Uri.parse("${ENDP.GET_BLOGS}");
    final response = await http.get(url, headers: {
      "Content-Type": "application/json", "Authorization": "Bearer "+access_token.$,
      "App-Language": app_language.$
    });
    print(url);
    print(response.body.toString());

    return blogPostResponseFromJson(response.body);
  }


  //Community View- Posts
  Future<BlogPostResponse> getBeautyBlogPosts() async {
    Uri url = Uri.parse("${ENDP.GET_BLOGS}");
    final response = await http.get(url, headers: {
      "Content-Type": "application/json", "Authorization": "Bearer "+access_token.$,
      "App-Language": app_language.$
    });
    print(url);
    print(response.body.toString());

    return blogPostResponseFromJson(response.body);
  }


  //Community View- Posts

  Future<CommunityPostResponse> getCommunityPosts() async {
    Uri url = Uri.parse("${ENDP.COMMUNITY_POSTS}");
    final response = await http.get(url, headers: {
      "Content-Type": "application/json", "Authorization": "Bearer "+access_token.$,
      "App-Language": app_language.$
    });
    print(url);
    print(response.body.toString());

    return communityPostResponseFromJson(response.body);
  }

  Future<CommunityHashtags> getCommunityHashTags() async {
    Uri url = Uri.parse("${ENDP.COMMUNITY_HASH}");
    final response = await http.get(url, headers: {
      "App-Language": app_language.$,
    });
    print(url);
    print(response.body.toString());

    return communityHashtagsFromJson(response.body);
  }



  ////Community Create- Post

  Future<NewCommunityPostResponse> getNewCommunityPostResponse(
      String image,
      String filename,
     // String title,
      String description,
    //  String hashtags

      ) async {
    var post_body = jsonEncode({
      "banner": "${image}",
      "filename": "$filename",
      "description": "$description",
      // "title": "$title",
     // "hashtags": "$hashtags",
    });
    //print(post_body.toString());

    Uri url = Uri.parse("${ENDP.COMMUNITY_POST_CREATE}");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer "+access_token.$,
          "App-Language": app_language.$,
        },
        body: post_body);

    //print(response.body.toString());
    return newCommunityPostResponseFromJson(response.body);
  }


//Community Create- Comment

  Future<AddCommunityComment> getCommunityCommentCreateResponse(
      String comment,
      int post_id,
     // String customer_id,
     // String parent_id,
      ) async {

    var post_body = jsonEncode({
      "comment": "${comment}",
      "post_id": "$post_id",
      "customer_id": "${user_id.$}",
     // "parent_id": "$parent_id"
    });

    Uri url = Uri.parse("${ENDP.COMMUNITY_POST_COMMENT_CREATE}");
    final response = await http.post(url,
        headers: {"Content-Type": "application/json", "Authorization": "Bearer "+access_token.$,"App-Language": app_language.$,},body: post_body );

    print(url);
    print(response.body.toString());
    return addCommunityCommentFromJson(response.body);
  }


//Community Create- Like
  Future<AddCommunityLike> getCommunityLikeCreateResponse(
      String post_id
      ) async {

    var post_body = jsonEncode({
      "post_id": "$post_id"
    });

    Uri url = Uri.parse("${ENDP.COMMUNITY_POST_LIKE_CREATE}");
    final response = await http.post(url,
        headers: {"Content-Type": "application/json", "Authorization": "Bearer ${access_token.$}","App-Language": app_language.$,},body: post_body );
    print(url);
    print(response.body.toString());
    return addCommunityLikeFromJson(response.body);
  }




//Community View- Comments:::{post_id}
  Future<CommunityCommentResponse> getCommunityCommentResponse(
      int post_id
      ) async {

    var post_body = jsonEncode({
      //"post_id": "$post_id"
    });

    Uri url = Uri.parse("${ENDP.COMMUNITY_POST_COMMENT}/$post_id");
    final response = await http.get(url, headers: {
      "Content-Type": "application/json", "Authorization": "Bearer "+access_token.$,
      "App-Language": app_language.$
    });
    print(url);
    print(response.body.toString());
    return communityCommentResponseFromJson(response.body);
  }




}
