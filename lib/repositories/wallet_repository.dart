import 'package:kirei/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:kirei/data_model/wallet_balance_response.dart';
import 'package:kirei/data_model/wallet_recharge_response.dart';
import 'package:kirei/helpers/shared_value_helper.dart';

class WalletRepository {
  Future<WalletBalanceResponse> getBalance() async {
    Uri url = Uri.parse("${AppConfig.BASE_URL}/wallet/balance");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );
    return walletBalanceResponseFromJson(response.body);
  }

  Future<WalletRechargeResponse> getRechargeList({int page = 1}) async {
    Uri url = Uri.parse(
        "${AppConfig.BASE_URL}/wallet/history?page=${page}");
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer ${access_token.$}",
        "App-Language": app_language.$,
      },
    );

    return walletRechargeResponseFromJson(response.body);
  }
}
