import 'package:active_ecommerce_flutter/screens/BeautyBooks.dart';
import 'package:active_ecommerce_flutter/screens/blogs.dart';
import 'package:active_ecommerce_flutter/screens/change_language.dart';
import 'package:active_ecommerce_flutter/screens/common_webview_screen.dart';
import 'package:active_ecommerce_flutter/screens/kireiYT.dart';
import 'package:active_ecommerce_flutter/screens/newsfeed.dart';
import 'package:active_ecommerce_flutter/screens/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:active_ecommerce_flutter/screens/main.dart';
import 'package:active_ecommerce_flutter/screens/profile.dart';
import 'package:active_ecommerce_flutter/screens/order_list.dart';
import 'package:active_ecommerce_flutter/screens/wishlist.dart';

import 'package:active_ecommerce_flutter/screens/login.dart';
import 'package:active_ecommerce_flutter/screens/messenger_list.dart';
import 'package:active_ecommerce_flutter/screens/wallet.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/helpers/auth_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({
    Key key,
  }) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  onTapLogout(context) async {
    AuthHelper().clearUserData();

    // var logoutResponse = await AuthRepository().getLogoutResponse();
    //
    // if (logoutResponse.result == true) {
    //   ToastComponent.showDialog(logoutResponse.message, context,
    //       gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
    //
    //   Navigator.push(context, MaterialPageRoute(builder: (context) {
    //     return Login();
    //   }));
    // }
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return Main();
    }), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Directionality(
        textDirection:
            app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
        child: Container(
          padding: EdgeInsets.only(top: 50),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                is_logged_in.$ == true
                    ? ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            "${avatar_original.$}" ??
                                "https://www.sealtightroofingexperts.com/wp-content/uploads/2023/04/avataaars-2.png",
                          ),
                        ),
                        title: Text("${user_name.$}"),
                        subtitle: Text(
                          //if user email is not available then check user phone if user phone is not available use empty string
                          "${user_email.$ != "" && user_email.$ != null ? user_email.$ : user_phone.$ != "" && user_phone.$ != null ? user_phone.$ : ''}",
                        ))
                    : Text(
                        AppLocalizations.of(context).main_drawer_not_logged_in,
                        style: TextStyle(
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme
                                .primary,
                            fontSize: 14)),
                Divider(),
                ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    leading: Image.asset("assets/home.png",
                        height: 16,
                        color:
                            Theme.of(context).buttonTheme.colorScheme.primary),
                    title: Text(AppLocalizations.of(context).main_drawer_home,
                        style: TextStyle(
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme
                                .primary,
                            fontSize: 14)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Main();
                      }));
                    }),
                ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    leading: Image.asset("assets/theme.png",
                        height: 16,
                        color:
                            Theme.of(context).buttonTheme.colorScheme.primary),
                    title: Text('Theme',
                        style: TextStyle(
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme
                                .primary,
                            fontSize: 14)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return DynamicThemesExampleApp();
                      }));
                    }),
                ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    leading: Image.asset("assets/blog.jpg",
                        height: 22,
                        color:
                            Theme.of(context).buttonTheme.colorScheme.primary),
                    title: Text('Kirei Blogs',
                        style: TextStyle(
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme
                                .primary,
                            fontSize: 14)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Blogs();
                      }));
                    }),
                ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    leading: Image.asset(
                      "assets/community.png",
                      height: 25,
                    ),
                    title: Text('Kirei Community',
                        style: TextStyle(
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme
                                .primary,
                            fontSize: 14)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return FeedList();
                      }));
                    }),
                ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    leading: Image.asset("assets/kyt.png", height: 22),
                    title: Text('Kirei Youtube',
                        style: TextStyle(
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme
                                .primary,
                            fontSize: 14)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return kireiYT();
                      }));
                    }),
                ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    leading: Image.asset("assets/bb.png", height: 24),
                    title: Text('Beauty Books',
                        style: TextStyle(
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme
                                .primary,
                            fontSize: 14)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return BeautyBooks();
                      }));
                    }),
                ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    leading: Image.asset("assets/app_logo.png", height: 24),
                    title: Text('Support Policy',
                        style: TextStyle(
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme
                                .primary,
                            fontSize: 14)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CommonWebviewScreen(
                          url: "https://kireibd.com/contact-us",
                          page_name: AppLocalizations.of(context)
                              .product_details_screen_support_policy,
                        );
                      }));
                    }),
                ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    leading: Image.asset("assets/app_logo.png", height: 24),
                    title: Text('Return Policy',
                        style: TextStyle(
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme
                                .primary,
                            fontSize: 14)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return CommonWebviewScreen(
                          url: "https://kireibd.com/contact-us",
                          page_name: AppLocalizations.of(context)
                              .product_details_screen_return_policy,
                        );
                      }));
                    }),
                is_logged_in.$ == true
                    ? Column(
                        children: [
                          ListTile(
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              leading: Image.asset("assets/profile.png",
                                  height: 16,
                                  color: Theme.of(context)
                                      .buttonTheme
                                      .colorScheme
                                      .primary),
                              title: Text(
                                  AppLocalizations.of(context)
                                      .main_drawer_profile,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .buttonTheme
                                          .colorScheme
                                          .primary,
                                      fontSize: 14)),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Profile(show_back_button: true);
                                }));
                              }),
                          ListTile(
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              leading: Image.asset("assets/order.png",
                                  height: 16,
                                  color: Theme.of(context)
                                      .buttonTheme
                                      .colorScheme
                                      .primary),
                              title: Text(
                                  AppLocalizations.of(context)
                                      .main_drawer_orders,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .buttonTheme
                                          .colorScheme
                                          .primary,
                                      fontSize: 14)),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return OrderList(from_checkout: false);
                                }));
                              }),
                          ListTile(
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              leading: Image.asset("assets/chat.png",
                                  height: 16,
                                  color: Theme.of(context)
                                      .buttonTheme
                                      .colorScheme
                                      .primary),
                              title: Text(
                                  AppLocalizations.of(context)
                                      .main_drawer_messages,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .buttonTheme
                                          .colorScheme
                                          .primary,
                                      fontSize: 14)),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return MessengerList();
                                }));
                              }),
                          wallet_system_status.$
                              ? ListTile(
                                  visualDensity: VisualDensity(
                                      horizontal: -4, vertical: -4),
                                  leading: Image.asset("assets/wallet.png",
                                      height: 16,
                                      color: Theme.of(context)
                                          .buttonTheme
                                          .colorScheme
                                          .primary),
                                  title: Text(
                                      AppLocalizations.of(context)
                                          .main_drawer_wallet,
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .buttonTheme
                                              .colorScheme
                                              .primary,
                                          fontSize: 14)),
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return Wallet();
                                    }));
                                  })
                              : Container(),
                        ],
                      )
                    : Container(),
                Divider(height: 24),
                is_logged_in.$ == false
                    ? ListTile(
                        visualDensity:
                            VisualDensity(horizontal: -4, vertical: -4),
                        leading: Image.asset("assets/login.png",
                            height: 16,
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme
                                .primary),
                        title: Text(
                            AppLocalizations.of(context).main_drawer_login,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .buttonTheme
                                    .colorScheme
                                    .primary,
                                fontSize: 14)),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Login();
                          }));
                        },
                      )
                    : Container(),
                is_logged_in.$ == true
                    ? ListTile(
                        visualDensity:
                            VisualDensity(horizontal: -4, vertical: -4),
                        leading: Image.asset("assets/logout.png",
                            height: 16,
                            color: Color.fromRGBO(153, 153, 153, 1)),
                        title: Text(
                            AppLocalizations.of(context).main_drawer_logout,
                            style: TextStyle(
                                color: Color.fromRGBO(153, 153, 153, 1),
                                fontSize: 14)),
                        onTap: () {
                          onTapLogout(context);
                        })
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
