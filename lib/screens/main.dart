import 'dart:io';
import 'package:active_ecommerce_flutter/custom/CommonFunctoins.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/cart.dart';
import 'package:active_ecommerce_flutter/screens/category_list.dart';
import 'package:active_ecommerce_flutter/screens/home.dart';
import 'package:active_ecommerce_flutter/screens/login.dart';
import 'package:active_ecommerce_flutter/screens/profile.dart';
import 'package:active_ecommerce_flutter/screens/filter.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gradients/flutter_gradients.dart';

import 'newsfeed.dart';
// ignore: must_be_immutable
class Main extends StatefulWidget {
  Main({Key key, go_back = true}) : super(key: key);

  // ignore: non_constant_identifier_names
  bool go_back;

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  int _currentIndex = 0;
  var _children = [
    Home(),
    CategoryList(
      is_base_category: true,
    ),
    FeedList(),
    Cart(has_bottomnav: true),
    Profile()
  ];

  void onTapped(int i) {
    if (!is_logged_in.$ && (i == 4 || i == 3)) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      return;
    }
    setState(() {
      _currentIndex = i;
    });
    print("i$i");
  }

  void initState() {
    // TODO: implement initState
    //re appear statusbar in case it was not there in the previous page
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print("_currentIndex");
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return false;
        } else {
          CommonFunctions(context).appExitDialog();
        }
        return widget.go_back;
      },
      child: Directionality(
        textDirection:
        app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          extendBody: true,
          body: _children[_currentIndex],
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
          //specify the location of the FAB

          bottomNavigationBar: ConvexAppBar(
            onTap: onTapped,
            initialActiveIndex: 0,
           // backgroundColor: Colors.deepPurple.shade400,
            style: TabStyle.flip,
            elevation: 1,
            height: 50,
           // cornerRadius: 20,
            curve: Curves.bounceOut,
            gradient: LinearGradient(
            colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
            ]),
/*            gradient: FlutterGradients.orangeJuice(
              type: GradientType.linear,
              center: Alignment.center,
            ),*/
            items: [
              TabItem(
                icon: Icons.home_outlined,
                title: AppLocalizations.of(context)
                    .main_screen_bottom_navigation_home,
              ),
              TabItem(
                icon: Icons.list_rounded,
                title: AppLocalizations.of(context)
                    .main_screen_bottom_navigation_categories,
              ),
              TabItem(icon: Icons.view_list_outlined, title: 'News feed'),
              TabItem(
                icon: Icons.shopping_cart,
                title: AppLocalizations.of(context)
                    .main_screen_bottom_navigation_cart,
              ),
              TabItem(
                icon: Icons.account_circle_sharp,
                title: AppLocalizations.of(context).main_screen_bottom_navigation_profile,
              ),
            ],
          ),

        ),
      ),
    );
  }
}
