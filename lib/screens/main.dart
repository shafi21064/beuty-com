
import 'package:kirei/custom/CommonFunctoins.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:kirei/main.dart';
import 'package:kirei/my_theme.dart';
import 'package:kirei/providers/cart_count_update.dart';
import 'package:kirei/providers/category_passing_controller.dart';
import 'package:kirei/repositories/cart_repository.dart';
import 'package:kirei/screens/cart.dart';
import 'package:kirei/screens/home.dart';
import 'package:kirei/screens/login.dart';
import 'package:kirei/screens/profile.dart';
import 'package:kirei/screens/filter.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data_model/product_mini_response_old.dart';

// ignore: must_be_immutable
class Main extends StatefulWidget {
  int pageIndex;
  List<Product> data;
  //String filterSlug;
  Main({Key key, go_back = true, this.pageIndex,
    this.data
  }) : super(key: key);

  // ignore: non_constant_identifier_names
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

 // List<Widget> _children;

  void onTapped(int i) {

    if (!is_logged_in.$ && (i == 4 || i == 3)) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      return;
    }

    setState(() {
      _currentIndex = i;
      widget.pageIndex = _currentIndex ;
    });


    if(widget.pageIndex != 1){
      Provider.of<CategoryPassingController>(context, listen: false).resetCategoryKeyValue();
    }
  }

  void initState() {
    // TODO: implement initState
    //re appear statusbar in case it was not there in the previous page
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);


    super.initState();
    // _children = [
    //   Home(),
    //   Filter(data: widget.data,),
    //   Cart(has_bottomnav: true),
    //   Profile(),
    // ];
    if (is_logged_in.$ == true) {
      fetchData();
    }




  }



  var cartItemCount = 0;
  var _shopList;
  var _isInitial = true;



fetchData() async {
  print(user_id.$);

  var cartResponseList =
      await CartRepository().getCartResponseList(user_id.$, context);

  print('cartResponse list ${cartResponseList}');
  if (cartResponseList != null && cartResponseList.length > 0) {
    _shopList = cartResponseList;
    int updatedCartItemCount = 0;

    for (var shop in _shopList) {
      for (var item in shop.cart_items) {
        updatedCartItemCount += item.quantity;
      }
    }

    setState(() {
      cartItemCount = updatedCartItemCount;
    });
  }

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setInt("cartItemCount", cartItemCount);


  _isInitial = false;
}




  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0 || widget.pageIndex !=0) {

           Navigator.push(context, MaterialPageRoute(builder: (_)=> Main(pageIndex: 0,)));
          // Navigator.pop(context);
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
          body: _children[widget.pageIndex ?? _currentIndex],
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
          //specify the location of the FAB

          bottomNavigationBar: ConvexAppBar(
            onTap: onTapped,
            initialActiveIndex: widget.pageIndex ?? 0,
            backgroundColor: MyTheme.primary,
            style: TabStyle.react,
            elevation: 1,
            height: 50,
            // cornerRadius: 20,
            curve: Curves.bounceOut,
            color: Colors.white,

            items: [
              TabItem(
                icon: Icons.home_outlined,
                title: AppLocalizations.of(context)
                    .main_screen_bottom_navigation_home,
              ),

              TabItem(icon: Icons.storefront_outlined, title: 'Shop'),
              TabItem(
                //icon: Icons.shopping_bag_outlined,
                icon:     badges.Badge(
                  badgeContent: Consumer<CartCountUpdate>(builder: (widget, value, child){
                    return Text(
                      //"${value.cartCount}",
                      "${sharedPreferences.getInt("cartItemCount") ?? 0}",
                      //cartItemCount.toString(),
                      style: TextStyle(
                          color: MyTheme.white
                      ),
                    );
                  }),
                  badgeColor: MyTheme.secondary,
                  child: Icon(Icons.shopping_bag_outlined, color: MyTheme.white,),
                ),
                title: AppLocalizations.of(context)
                    .main_screen_bottom_navigation_cart,
              ),
              TabItem(
                  icon: Icons.account_circle_rounded,
                  title: AppLocalizations.of(context)
                      .main_screen_bottom_navigation_profile),
            ],
          ),
        ),
      ),
    );
  }
}
