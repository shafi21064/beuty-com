import 'package:flutter/cupertino.dart';
import 'package:flutter_icons/flutter_icons.dart';

class CategoryPassingController with ChangeNotifier{

  String _categoryKey;
  String _typeKey;
  String _searchKey;

  String get categoryKey => _categoryKey;
  String get typeKey => _typeKey;
  String get searchKey => _searchKey;

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

  void setSearchKey(searchKeyValue){
    _searchKey = searchKeyValue;
  }

  void ResetValue(){
    _categoryKey = '';
    _typeKey= '';
  }
}