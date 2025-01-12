import 'package:flutter/material.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:kirei/repositories/cart_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartCountUpdate extends ChangeNotifier {
  int _cartCount = 0;
  int get cartCount => _cartCount;

  getIncrease() async {
    if(user_name.$ != null ) {
      SharedPreferences sharedPreferences = await SharedPreferences
          .getInstance();
      _cartCount = sharedPreferences.getInt("cartItemCount") ?? 0;
      _cartCount++;
      sharedPreferences.setInt("cartItemCount", _cartCount);
      notifyListeners();
    }
  }

  getDecrease() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _cartCount = sharedPreferences.getInt("cartItemCount") ?? 0;
    if (_cartCount > 0) {
      _cartCount--;
      sharedPreferences.setInt("cartItemCount", _cartCount);
      notifyListeners();
    }
  }

  getReorderCart(String item) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //_cartCount = sharedPreferences.getInt("cartItemCount") ?? 0;
    _cartCount = 0;
    _cartCount +=  int.parse(item);
    sharedPreferences.setInt("cartItemCount", _cartCount);
    notifyListeners();
  }

  getReset() async {
    _cartCount = 0;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt("cartItemCount", _cartCount);
    notifyListeners();
  }

 getDelete(BuildContext context) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  var cartResponseList =
      await CartRepository().getCartResponseList(user_id.$,context);

  print('cartResponse list ${cartResponseList}');

  int updateCartCount = 0;

  if (cartResponseList != null && cartResponseList.length > 0) {
    var demolist = cartResponseList[0].cart_items;

    demolist.forEach((val1) {
      updateCartCount += val1.quantity;
    });
  }

  sharedPreferences.setInt("cartItemCount", updateCartCount);
  notifyListeners();
}

 setCartValue(int currentValue)async{
   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _cartCount = sharedPreferences.getInt("cartItemCount");
    _cartCount += currentValue;
    sharedPreferences.setInt("cartItemCount", _cartCount);
    notifyListeners();
 }

}
