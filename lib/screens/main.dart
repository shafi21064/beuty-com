import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:kirei/screens/cart.dart';
import 'package:kirei/screens/filter.dart';
import 'package:kirei/screens/home.dart';
import 'package:kirei/screens/login.dart';
import 'package:kirei/screens/profile.dart';

class Main extends StatefulWidget {
  Main({Key key, go_back = true}) : super(key: key);

  bool go_back;

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  int _currentIndex = 0;
  var _children = [
    Home(),
    Filter(),
    Cart(has_bottomnav: true),
    Profile(),
  ];

  void onTapped(int i) {
    if (i == 2 && !is_logged_in.$) {
      // If it's the cart page and not logged in, navigate to the login page
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      return;
    }
    setState(() {
      _currentIndex = i;
    });
    print("i$i");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return false;
        } else {
          // CommonFunctions(context).appExitDialog();
        }
        return widget.go_back;
      },
      child: Directionality(
        textDirection:
            app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          extendBody: true,
          body: _children[_currentIndex],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.blue, // Change the background color
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, -1),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: onTapped,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white, // Change the background color
              selectedItemColor: Colors.black, // Change the active tab color
              unselectedItemColor: Colors.grey, // Change the inactive tab color
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: AppLocalizations.of(context)
                      .main_screen_bottom_navigation_home,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.view_list_sharp),
                  label: 'Shop',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  label: AppLocalizations.of(context)
                      .main_screen_bottom_navigation_cart,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle_sharp),
                  label: AppLocalizations.of(context)
                      .main_screen_bottom_navigation_profile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
