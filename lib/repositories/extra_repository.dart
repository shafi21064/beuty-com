import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:kirei/app_config.dart';
import 'package:kirei/data_model/extra/BlogPostResponse.dart';
import 'package:kirei/data_model/extra/CommunityCommentResponse.dart';
import 'package:kirei/data_model/extra/NewCommunityPostResponse.dart';
import 'package:kirei/data_model/extra/addCommunityComment.dart';
import 'package:kirei/data_model/extra/addCommunityLike.dart';
import 'package:kirei/data_model/extra/deactive_account_model.dart';
import 'package:kirei/data_model/extra_community_HashTags_response.dart';
import 'package:kirei/data_model/extra_community_response.dart';
import 'package:kirei/helpers/endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:kirei/helpers/shared_value_helper.dart';

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

  // Future<CommunityPost> getCommunityPosts() async {
  //   Uri url = Uri.parse("${ENDP.COMMUNITY_POSTS}");
  //   final response = await http.get(url, headers: {
  //     "Content-Type": "application/json",
  //     "Authorization": "Bearer ${access_token.$}",
  //     "App-Language": app_language.$
  //   });
  //   print(url);
  //   print(response.body.toString());
  //
  //   return CommunityPost.fromJson(jsonDecode(response.body));
  // }

  Future<CommunityPostResponse> getCommunityPosts() async {
    Uri url = Uri.parse("${ENDP.COMMUNITY_POSTS}");
    final response = await http.get(url,
        headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${access_token.$}",
      "App-Language": app_language.$
    });
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

  // Future<NewCommunityPostResponse> getNewCommunityPostResponse(
  //     String image,
  //     String filename,
  //    // String title,
  //     String description,
  //   //  String hashtags
  //
  //     ) async {
  //   var post_body = jsonEncode({
  //     "banner": "${image}",
  //     "filename": "$filename",
  //     "description": "$description",
  //     // "title": "$title",
  //    // "hashtags": "$hashtags",
  //   });
  //   print("PostData: ${post_body.toString()}");
  //
  //   Uri url = Uri.parse("${ENDP.COMMUNITY_POST_CREATE}");
  //   final response = await http.post(url,
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer "+access_token.$,
  //         "App-Language": app_language.$,
  //       },
  //       body: post_body);
  //
  //   print("KireiBdApp100: ${response.body.toString()}");
  //   return newCommunityPostResponseFromJson(response.body);
  // }

  Future<NewCommunityPostResponse> getNewCommunityPostResponse(
      File imageFile,
      String filename,
      String description,
      ) async {
    // Ensure the file exists
    if (!imageFile.existsSync()) {
      print("File does not exist");
      throw Exception("File does not exist");
    }

    // Define the endpoint URL
    Uri url = Uri.parse("${ENDP.COMMUNITY_POST_CREATE}"); // Replace with your actual endpoint URL

    // Create the multipart request
    var request = http.MultipartRequest('POST', url);

    // Add the file to the request
    request.files.add(
      await http.MultipartFile.fromPath(
        'banner', // The name of the field in the request, should match the expected field name on server
        imageFile.path,
        filename: filename,
      ),
    );

    // Add other fields to the request
    request.fields['description'] = description;
    request.fields['type'] = 'app';

    // Add headers to the request
    request.headers.addAll({
      "Authorization": "Bearer ${access_token.$}", // Replace with your actual access token
      "App-Language": app_language.$, // Replace with the actual language if needed
    });

    try {
      // Send the request and get the response
      var response = await request.send();

      // Check the response status
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        print("Image uploaded successfully: $responseBody");
        return newCommunityPostResponseFromJson(responseBody);
      } else {
        print("Image upload failed with status: ${response.statusCode}");
        throw Exception('Failed to create post');
      }
    } catch (e) {
      print("Exception occurred: $e");
      throw e;
    }
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

  ///De-active Account
  Future<DeactivationResponse> deActiveUserAccount() async{
    final response = await http.post(Uri.parse(ENDP.deleteAccount),
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer "+access_token.$,
    });

    if(response.statusCode == 200){
      var responseBody = jsonDecode(response.body);
      return DeactivationResponse.fromJson(responseBody);
    }else{
      throw Error();
    }
  }

}
