import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:kirei/repositories/auth_repository.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  setUserData(loginResponse) async{
    print(loginResponse);
    if (loginResponse.result == true) {
      is_logged_in.$ = true;
      is_logged_in.save();
      access_token.$ = loginResponse.access_token ?? '';
      access_token.save();
      user_id.$ = loginResponse.user?.id;
      user_id.save();
      user_name.$ = loginResponse.user?.name ?? '';
      user_name.save();
      user_email.$ = loginResponse.user?.email;
      user_email.save();
      user_phone.$ = loginResponse.user?.phone;
      user_phone.save();
      user_have_password.$ = "${loginResponse.user?.password_saved}";
      user_have_password.save();
      avatar_original.$ = loginResponse.user?.avatar_original ?? '';
      avatar_original.save();
    }
  }

  setUserDataFromOTP(loginResponse) {
    print(loginResponse);
    if (loginResponse.result == true) {
      is_logged_in.$ = true;
      is_logged_in.save();
      access_token.$ = loginResponse.access_token ?? '';
      access_token.save();
      user_phone.$ = loginResponse.phone;
      user_phone.save();
      user_id.$ = loginResponse.user?.id;
      user_id.save();
      print(user_id.$);
      user_name.$ = loginResponse.user?.name ?? '';
      user_name.save();
      user_email.$ = loginResponse.user?.email ?? '';
      user_email.save();
      user_phone.$ = loginResponse.user?.email ?? '';
      user_phone.save();
      user_have_password.$ = "${loginResponse.user?.password_saved}";
      user_have_password.save();
      avatar_original.$ = loginResponse.user?.avatar_original ?? '';
      avatar_original.save();
    }
  }

  clearUserData() {
    is_logged_in.$ = false;
    is_logged_in.save();
    access_token.$ = "";
    access_token.save();
    user_id.$ = 0;
    user_id.save();
    user_name.$ = "";
    user_name.save();
    user_email.$ = "";
    user_email.save();
    user_phone.$ = "";
    user_phone.save();
    user_have_password.$ = "";
    user_have_password.save();
    avatar_original.$ = "";
    avatar_original.save();
  }

  fetch_and_set() async {
    var userByTokenResponse = await AuthRepository().getUserByTokenResponse();

    if (userByTokenResponse.result == true) {
      is_logged_in.$ = true;
      is_logged_in.save();
      user_id.$ = userByTokenResponse.id;
      user_id.save();
      user_name.$ = userByTokenResponse.name;
      user_name.save();
      user_email.$ = userByTokenResponse.email;
      user_email.save();
      user_phone.$ = userByTokenResponse.phone;
      user_phone.save();
      user_have_password.$ = "${userByTokenResponse.password_saved}";
      user_have_password.save();
      avatar_original.$ = userByTokenResponse.avatar_original ?? '';
      avatar_original.save();
    } else {
      is_logged_in.$ = false;
      is_logged_in.save();
      user_id.$ = 0;
      user_id.save();
      user_name.$ = "";
      user_name.save();
      user_email.$ = "";
      user_email.save();
      user_phone.$ = "";
      user_phone.save();
      user_have_password.$ = "";
      user_have_password.save();
      avatar_original.$ = "";
      avatar_original.save();
    }
  }
}
