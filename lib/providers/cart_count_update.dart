import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartCountUpdate extends ChangeNotifier {


  int _cartCount = 0;
  get cartCount => _cartCount;
  int _productQuantity;
  get productQuantity => _productQuantity;

  getIncrease()async{
    print('cart provider ' +_cartCount.toString());
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _cartCount= sharedPreferences.getInt("cartItemCount");
    _cartCount++;
    sharedPreferences.setInt("cartItemCount", _cartCount);
    print("update value: "+ sharedPreferences.getInt("cartCount").toString());
    notifyListeners();
  }

  getDecrease()async{
    _cartCount--;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt("cartItemCount", _cartCount);
    print("update value: "+ sharedPreferences.getInt("cartCount").toString());
    notifyListeners();
  }

  getReset()async{
    _cartCount = 0;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt("cartItemCount", _cartCount);
    print("update value: "+ sharedPreferences.getInt("cartCount").toString());
    notifyListeners();
  }

  getDelete()async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _cartCount= sharedPreferences.getInt("cartItemCount");
    sharedPreferences.setInt("cartItemCount", _cartCount);
    // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // sharedPreferences.setInt("cartItemCount", _cartCount);
    // print("update value: "+ sharedPreferences.getInt("cartCount").toString());
    notifyListeners();
  }

}