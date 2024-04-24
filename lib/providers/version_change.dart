import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class VersionChange with ChangeNotifier{

 dynamic _latestVersion ;
 dynamic get latestVersion => _latestVersion;


 Future<void> changeVersion() async{
   PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _latestVersion = packageInfo.version;
    notifyListeners();
 }

}

