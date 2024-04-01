import 'package:flutter/cupertino.dart';

class CategoryPassingController with ChangeNotifier{

  String _categoryKey;
  String _typeKey;
  String _searchKey;
  String _tagsKey;
  String _skinTypesKey;
  String _ingredientsKey;
  String _goodForKey;


  String get categoryKey => _categoryKey;
  String get typeKey => _typeKey;
  String get searchKey => _searchKey;
  String get tagsKey => _tagsKey;
  String get skinTypesKey => _skinTypesKey;
  String get ingredientsKey => _ingredientsKey;
  String get goodForKey => _goodForKey;

  void setCategoryKey(keyValue){
    _categoryKey = keyValue;
    notifyListeners();
  }

  void setTypeKey(typeKeyValue){
    _categoryKey = typeKeyValue;
    notifyListeners();
  }

  void setSearchKey(searchKeyValue){
    _searchKey = searchKeyValue;
    notifyListeners();
  }
  void setTagsKey(tagsKeyValue){
    _tagsKey = tagsKeyValue;
    notifyListeners();
  }
  void setSkinTypesKey(skinTypesValue){
    _skinTypesKey = skinTypesValue;
    notifyListeners();
  }
  void setIngredientsKey(ingredientsKeyValue){
    _ingredientsKey = ingredientsKeyValue;
    notifyListeners();
  }
  void setGoodForKey(goodForKeyValue){
    _goodForKey = goodForKeyValue;
    notifyListeners();
  }

  void resetCategoryKeyValue(){
    _categoryKey = '';
    _typeKey= '';
    _tagsKey= '';
    _searchKey = '';
    _ingredientsKey = '';
    _goodForKey = '';
    _skinTypesKey = '';
  }
}