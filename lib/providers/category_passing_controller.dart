import 'package:flutter/cupertino.dart';
import 'package:flutter_icons/flutter_icons.dart';

class CategoryPassingController with ChangeNotifier{

  String _categoryKey;
  String _typeKey;

  String get categoryKey => _categoryKey;
  String get typeKey => _typeKey;

  void setCategoryKey(keyValue){
    _categoryKey = keyValue;
    print('privet' +_categoryKey);
    print('public' +categoryKey);
    notifyListeners();
  }

  void setTypeKey(typeKeyValue){
    _categoryKey = typeKeyValue;
    print('privet' +_typeKey);
    print('public' +typeKey);
    notifyListeners();
  }

  void ResetValue(){
    _categoryKey = '';
    _typeKey= '';
  }
}