import 'package:kirei/helpers/auth_helper.dart';
import 'package:kirei/providers/cart_count_update.dart';
import 'package:kirei/screens/theme.dart';
import 'package:kirei/screens/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:kirei/my_theme.dart';
import 'package:kirei/ui_sections/drawer.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:kirei/screens/wallet.dart';
import 'package:kirei/screens/profile_edit.dart';
import 'package:kirei/screens/address.dart';
import 'package:kirei/screens/order_list.dart';
import 'package:kirei/repositories/profile_repository.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'main.dart';
import 'messenger_list.dart';

class Profile extends StatefulWidget {
  Profile({Key key, this.show_back_button = false}) : super(key: key);

  bool show_back_button;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ScrollController _mainScrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  onTapLogout(context) async {
    AuthHelper().clearUserData();

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt("cartItemCount", 0) ;

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return Main();
    }), (route) => false);
  }

  int _cartCounter = 0;
  String _cartCounterString = "...";
  int _wishlistCounter = 0;
  String _wishlistCounterString = "...";
  int _orderCounter = 0;
  String _orderCounterString = "...";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (is_logged_in.$ == true) {
      fetchAll();
    }
  }

  void dispose() {
    _mainScrollController.dispose();
    super.dispose();
  }

  Future<void> _onPageRefresh() async {
    reset();
    fetchAll();
  }

  onPopped(value) async {
    reset();
    fetchAll();
  }

  fetchAll() {
    fetchCounters();
  }

  fetchCounters() async {
    var profileCountersResponse =
        await ProfileRepository().getProfileCountersResponse();

    _cartCounter = profileCountersResponse.cart_item_count;
    _wishlistCounter = profileCountersResponse.wishlist_item_count;
    _orderCounter = profileCountersResponse.order_count;

    _cartCounterString =
        counterText(_cartCounter.toString(), default_length: 2);
    _wishlistCounterString =
        counterText(_wishlistCounter.toString(), default_length: 2);
    _orderCounterString =
        counterText(_orderCounter.toString(), default_length: 2);

    setState(() {});
  }

  String counterText(String txt, {default_length = 3}) {
    var blank_zeros = default_length == 3 ? "000" : "00";
    var leading_zeros = "";
    if (txt != null) {
      if (default_length == 3 && txt.length == 1) {
        leading_zeros = "00";
      } else if (default_length == 3 && txt.length == 2) {
        leading_zeros = "0";
      } else if (default_length == 2 && txt.length == 1) {
        leading_zeros = "0";
      }
    }

    var newtxt = (txt == null || txt == "" || txt == null.toString())
        ? blank_zeros
        : txt;



    if (default_length > txt.length) {
      newtxt = leading_zeros + newtxt;
    }


    return newtxt;
  }

  reset() {
    _cartCounter = 0;
    _cartCounterString = "...";
    _wishlistCounter = 0;
    _wishlistCounterString = "...";
    _orderCounter = 0;
    _orderCounterString = "...";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    var resetCartProductCount = Provider.of<CartCountUpdate>(context);

    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: MainDrawer(),
        backgroundColor: Colors.grey[200],
        appBar: buildAppBar(context),
        body: buildBody(context, (){

        }),
      ),
    );
  }

  buildBody(context, VoidCallback logout) {
    if (is_logged_in.$ == false) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context).profile_screen_please_log_in,
            style: TextStyle(color: MyTheme.secondary),
          )));
    } else {
      return RefreshIndicator(
        color: MyTheme.primary,
        backgroundColor: Colors.white,
        onRefresh: _onPageRefresh,
        displacement: 10,
        child: CustomScrollView(
          controller: _mainScrollController,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                buildTopSection(),
                //buildCountersRow(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(
                    height: 24,
                  ),
                ),
                buildDetailsMenu(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(
                    height: 24,
                  ),
                ),
                buildVerticalMenu(logout)
              ]),
            )
          ],
        ),
      );
    }
  }

  buildDetailsMenu(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return OrderList();
              }));
            },
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Orders",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: MyTheme.dark_grey
                    ),),
                  Divider(
                    thickness:1 ,
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ProfileEdit();
              })).then((value) {
                onPopped(value);
              });
            },
            child: Container(
              margin: EdgeInsets.only(top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Account Details",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: MyTheme.dark_grey
                    ),),
                  Divider(
                    thickness:1 ,
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Wishlist();
              }));
            },
            child: Container(
              margin: EdgeInsets.only(top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Wishlist",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: MyTheme.dark_grey
                    ),),
                  Divider(
                    thickness:1 ,
                  ),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
    return Address();
    }));},
            child: Container(margin: EdgeInsets.only(top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Address",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: MyTheme.dark_grey
                    ),),
                  Divider(
                    thickness:1 ,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildHorizontalMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Wishlist();
            }));
          },
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.all(8),
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.favorite,
                        color: Colors.green,
                      ),
                      Text(
                        "Wishlist",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: MyTheme.secondary,
                            fontWeight: FontWeight.w300,
                            fontSize: 11),
                      ),
                    ],
                  )),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ProfileEdit();
            })).then((value) {
              onPopped(value);
            });
          },
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.all(8),
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.person,
                        color: Colors.blueAccent,
                      ),
                      Text(
                        "Profile",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 11,
                            color: MyTheme.secondary,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  )),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Address();
            }));
          },
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.all(8),
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.amber,
                      ),
                      Text(
                        "Location",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: MyTheme.secondary,
                            fontWeight: FontWeight.w300,
                            fontSize: 10),
                      ),
                    ],
                  )),
            ],
          ),
        ),

      ],
    );
  }

  buildHorizontalMenu2() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return OrderList();
            }));
          },
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.all(8),
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        color: Colors.deepPurple,
                      ),
                      Text(
                        AppLocalizations.of(context).profile_screen_orders,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 10,
                            color: MyTheme.secondary,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  )),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MessengerList();
            }));
          },
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.all(8),
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.email_outlined,
                        color: Colors.deepOrange,
                      ),
                      Text(
                        "Inbox",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: MyTheme.secondary,
                            fontWeight: FontWeight.w300,
                            fontSize: 10),
                      ),
                    ],
                  )),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return DynamicThemesExampleApp();
            }));
          },
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.all(8),
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.theater_comedy_rounded,
                        color: Colors.pink,
                      ),
                      Text(
                        "Themes",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 10,
                            color: MyTheme.secondary,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  )),
            ],
          ),
        ),

      ],
    );
  }

  buildVerticalMenu(VoidCallback logout) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              onTapLogout(context);
              logout();
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0, top: 50),
              child: Row(
                children: [
                  Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.login,
                          color: Colors.white,
                          size: 14,
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      "Logout",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: MyTheme.secondary, fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildCountersRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _cartCounterString,
                style: TextStyle(
                    fontSize: 16,
                    color: MyTheme.secondary,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  AppLocalizations.of(context).profile_screen_in_your_cart,
                  style: TextStyle(
                    color: MyTheme.dark_grey,
                  ),
                )),
          ],
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _wishlistCounterString,
                style: TextStyle(
                    fontSize: 16,
                    color: MyTheme.secondary,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  AppLocalizations.of(context).profile_screen_in_wishlist,
                  style: TextStyle(
                    color: MyTheme.dark_grey,
                  ),
                )),
          ],
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _orderCounterString,
                style: TextStyle(
                    fontSize: 16,
                    color: MyTheme.secondary,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  AppLocalizations.of(context).profile_screen_in_ordered,
                  style: TextStyle(
                    color: MyTheme.dark_grey,
                  ),
                )),
          ],
        )
      ],
    );
  }

  buildTopSection() {
    return Column(
      children: [
        SizedBox(
          height: 170, // 240
          child: Stack(
            children: <Widget>[
              ClipPath(
                clipper: CustomShape(),
                child: Container(
                  height: 215, //150
                  decoration: BoxDecoration(
                    color: MyTheme.primary,
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2 * 0.8, //8
                        ),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: avatar_original.$ != null ? NetworkImage("${avatar_original.$}") : AssetImage('assets/placeholder.png') //TODO:change the avatar
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            "${user_name.$}",
            style: TextStyle(
                fontSize: 14,
                color: MyTheme.secondary,
                fontWeight: FontWeight.w600),
          ),
        ),

        Visibility(
          visible: wallet_system_status.$,
          child: Padding(
            padding: const EdgeInsets.only(top: 6.0, bottom: 10),
            child: Container(
              height: 24,
              decoration: BoxDecoration(color: MyTheme.primary),
              child: FlatButton(
                // 	rgb(50,205,50)
                shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.only(
                  topLeft: const Radius.circular(16.0),
                  bottomLeft: const Radius.circular(16.0),
                  topRight: const Radius.circular(16.0),
                  bottomRight: const Radius.circular(16.0),
                )),
                child: Text(
                  "${user_email.$ != "" && user_email.$ != null ? user_email.$ : user_phone.$ != "" && user_phone.$ != null ? user_phone.$ : ''}",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Wallet();
                  }));
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      //backgroundColor: Colors.white,
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(color: MyTheme.primary),
      ),
      leading: GestureDetector(
        child: widget.show_back_button
            ? Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              )
            : Builder(
                builder: (context) => GestureDetector(
                  onTap: () {
                    _scaffoldKey.currentState.openDrawer();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 18.0, horizontal: 0.0),
                    child: Container(
                      child: Image.asset('assets/hamburger.png',
                          height: 16,
                          color: Theme.of(context).primaryIconTheme.color),
                    ),
                  ),
                ),
              ),
      ),
      title: Text(AppLocalizations.of(context).profile_screen_account,
          style: GoogleFonts.ubuntu(fontSize: 18, color: Colors.white)),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }
}

class CustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double height = size.height;
    double width = size.width;
    path.lineTo(0, height - 100);
    path.quadraticBezierTo(width / 2, height, width, height - 100);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
