import 'dart:math';

import 'package:kirei/data_model/category_response.dart';
import 'package:kirei/my_theme.dart';
import 'package:kirei/repositories/category_repository.dart';
import 'package:kirei/screens/BeautyBooks.dart';
import 'package:kirei/screens/appointment.dart';
import 'package:kirei/screens/beauty_tips.dart';
import 'package:kirei/screens/blogs.dart';
import 'package:kirei/screens/change_language.dart';
import 'package:kirei/screens/common_webview_screen.dart';
import 'package:kirei/screens/filter.dart';
import 'package:kirei/screens/kireiYT.dart';
import 'package:kirei/screens/newsfeed.dart';
import 'package:kirei/screens/registration.dart';
import 'package:kirei/screens/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:kirei/screens/main.dart';
import 'package:kirei/screens/profile.dart';
import 'package:kirei/screens/order_list.dart';
import 'package:kirei/screens/wishlist.dart';

import 'package:kirei/screens/login.dart';
import 'package:kirei/screens/messenger_list.dart';
import 'package:kirei/screens/wallet.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:kirei/app_config.dart';
import 'package:kirei/helpers/auth_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({
    Key key,
  }) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      CategoryRepository categoryRepository = CategoryRepository();
      var categoryResponse = await categoryRepository.getCategories();
      setState(() {
        categories = categoryResponse.categories ?? [];
      });
    } catch (error) {
      print('Error fetching data: $error');
      // Handle error as needed
    }
  }

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
          padding: EdgeInsets.only(top: 50, left: 5),
          child: SingleChildScrollView(
            //scrollDirection: Axis.vertical,
            physics: ClampingScrollPhysics(),
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
                        style: TextStyle(fontSize: 13)),
                Divider(),
                ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    // leading: Image.asset("assets/home.png",
                    //     height: 16,
                    //     color:
                    //         Theme.of(context).buttonTheme.colorScheme.primary),
                    title: Text(
                        AppLocalizations.of(context)
                            .main_drawer_home
                            .toUpperCase(),
                        style: TextStyle(fontSize: 13)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Main();
                      }));
                    }
                    ),
                ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    // leading: Image.asset("assets/blog.jpg",
                    //     height: 22,
                    //     color:
                    //         Theme.of(context).buttonTheme.colorScheme.primary),
                    title: Text('New Arrivals'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 13,
                        )),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return Filter();
                          }));
                    }),
                ExpansionTile(
                  // leading: Icon(Icons.category,
                  //     color: Theme.of(context).buttonTheme.colorScheme.primary),
                  title: Row(
                    children: [
                      Text(
                        "Categories".toUpperCase(),
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),

                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),

                      Stack(
                        children: [
                          Transform.rotate(
                            angle: pi/5,
                            child: Container(
                              margin: EdgeInsets.only(
                                top: 3
                              ),
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.pinkAccent,
                              ),
                            ),
                          ),
                          Container(
                            height: 22,
                            width: 45,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Colors.pinkAccent,
                                borderRadius: BorderRadius.circular(2)
                            ),
                            child: Text("New!",
                              style: TextStyle(
                                  color: MyTheme.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  children: categories.map((category) {
                    return category.children != null &&
                            category.children.isNotEmpty
                        ? ExpansionTile(
                            title: Text(category.name),
                            children: category.children.map((child) {
                              return ListTile(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Filter(category:child.name);
                                  }));
                                },
                                visualDensity:
                                    VisualDensity(horizontal: -4, vertical: -4),
                                title: Text(child.name),
                              );
                            }).toList(),
                          )
                        : ListTile(
                          onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Filter(category:category.name);
                      }));
                    },
                            visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
                            title: Text(category.name),
                          );
                  }).toList(),
                ),
                // ListTile(
                //     visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                //     // leading: Image.asset("assets/blog.jpg",
                //     //     height: 22,
                //     //     color:
                //     //         Theme.of(context).buttonTheme.colorScheme.primary),
                //     title: Text('brands'.toUpperCase(),
                //         style: TextStyle(
                //           fontSize: 13,
                //         )),
                //     onTap: () {
                //       // Navigator.push(context,
                //       //     MaterialPageRoute(builder: (context) {
                //       //   return BeautyTips();
                //       // }));
                //     }),
                ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    // leading: Image.asset("assets/blog.jpg",
                    //     height: 22,
                    //     color:
                    //         Theme.of(context).buttonTheme.colorScheme.primary),
                    title: Text('beauty tips'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 13,
                        )),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return BeautyTips();
                      }));
                    }),
                // ListTile(
                //     visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                //     // leading: Image.asset("assets/blog.jpg",
                //     //     height: 22,
                //     //     color:
                //     //         Theme.of(context).buttonTheme.colorScheme.primary),
                //     title: Text('personal recommendation'.toUpperCase(),
                //         style: TextStyle(
                //           fontSize: 13,
                //         )),
                //     onTap: () {
                //       // Navigator.push(context,
                //       //     MaterialPageRoute(builder: (context) {
                //       //   return BeautyTips();
                //       // }));
                //     }),
                ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    // leading: Image.asset(
                    //   "assets/community.png",
                    //   height: 25,
                    // ),
                    title: Text('Community'.toUpperCase(),
                        style: TextStyle(fontSize: 13)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return FeedList();
                          }));
                    }),
                ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    // leading: Image.asset("assets/blog.jpg",
                    //     height: 22,
                    //     color:
                    //         Theme.of(context).buttonTheme.colorScheme.primary),
                    title: Text('Appointment'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 13,
                        )),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Appointment();
                      }));
                    }),
                ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    // leading: Image.asset("assets/blog.jpg",
                    //     height: 22,
                    //     color:
                    //         Theme.of(context).buttonTheme.colorScheme.primary),
                    title: Text('Blog'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 13,
                        )),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Blogs();
                      }));
                    }),
                ExpansionTile(
                    // leading: Icon(Icons.category,
                    //     color: Theme.of(context).buttonTheme.colorScheme.primary),
                    title: Row(
                      children: [
                        Text(
                          "kirei".toUpperCase(),
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),

                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),

                        Container(
                          height: 22,
                          width: 45,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Color(0xff05ABE0),
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: Text("INFO",
                          style: TextStyle(
                            color: MyTheme.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500
                          ),
                          ),
                        )
                      ],
                    ),
                    children: [
                      ListTile(
                          visualDensity:
                              VisualDensity(horizontal: -4, vertical: -4),
                          // leading: Image.asset("assets/app_logo.png", height: 24),
                          title: Text('Who We Are?',
                              style: TextStyle(fontSize: 13)),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CommonWebviewScreen(
                                url: "https://kireibd.com/about-us?type=app",
                                page_name: 'Who We Are?',
                              );
                            }));
                          }),
                      ListTile(
                          visualDensity:
                              VisualDensity(horizontal: -4, vertical: -4),
                          // leading: Image.asset("assets/app_logo.png", height: 24),
                          title: Text('FAQs', style: TextStyle(fontSize: 13)),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CommonWebviewScreen(
                                url: "https://kireibd.com/faq?type=app",
                                page_name: "FAQs",
                              );
                            }));
                          }),
                      ListTile(
                          visualDensity:
                              VisualDensity(horizontal: -4, vertical: -4),
                          // leading: Image.asset("assets/app_logo.png", height: 24),
                          title: Text('Contact us',
                              style: TextStyle(fontSize: 13)),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CommonWebviewScreen(
                                url: "https://kireibd.com/contact-us?type=app",
                                page_name: "Contact Us",
                              );
                            }));
                          }),
                      ListTile(
                          visualDensity:
                              VisualDensity(horizontal: -4, vertical: -4),
                          // leading: Image.asset("assets/app_logo.png", height: 24),
                          title: Text('Testimonials',
                              style: TextStyle(fontSize: 13)),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CommonWebviewScreen(
                                url: "https://kireibd.com/testimonial?type=app",
                                page_name: 'Testimonials',
                              );
                            }));
                          }),
                      ListTile(
                          visualDensity:
                              VisualDensity(horizontal: -4, vertical: -4),
                          // leading: Image.asset("assets/app_logo.png", height: 24),
                          title: Text('Privacy & Policy',
                              style: TextStyle(fontSize: 13)),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CommonWebviewScreen(
                                url:
                                    "https://kireibd.com/privacy-policy?type=app",
                                page_name: "Privacy & Policy ",
                              );
                            }));
                          }),
                      ListTile(
                          visualDensity:
                              VisualDensity(horizontal: -4, vertical: -4),
                          // leading: Image.asset("assets/app_logo.png", height: 24),
                          title: Text('Terms & Conditions',
                              style: TextStyle(fontSize: 13)),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CommonWebviewScreen(
                                url:
                                    "https://kireibd.com/term-condition?type=app",
                                page_name: "Terms & Conditions",
                              );
                            }));
                          }),
                      ListTile(
                          visualDensity:
                              VisualDensity(horizontal: -4, vertical: -4),
                          // leading: Image.asset("assets/app_logo.png", height: 24),
                          title: Text('Returns & Refunds',
                              style: TextStyle(fontSize: 13)),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CommonWebviewScreen(
                                url:
                                    "hhttps://kireibd.com/return-refund?type=app",
                                page_name: 'Returns & Refunds',
                              );
                            }));
                          }),
                      ListTile(
                          visualDensity:
                              VisualDensity(horizontal: -4, vertical: -4),
                          // leading: Image.asset("assets/app_logo.png", height: 24),
                          title: Text('Responsible Disclosure',
                              style: TextStyle(fontSize: 13)),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CommonWebviewScreen(
                                url:
                                    "https://kireibd.com/responsible-disclosure?type=app",
                                page_name: 'Responsible Disclosure',
                              );
                            }));
                          })
                    ]),
                // ListTile(
                //     visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                //     // leading: Image.asset("assets/app_logo.png", height: 24),
                //     title:
                //         Text('Return Policy', style: TextStyle(fontSize: 13)),
                //     onTap: () {
                //       Navigator.push(context,
                //           MaterialPageRoute(builder: (context) {
                //         return CommonWebviewScreen(
                //           url: "https://kireibd.com/contact-us",
                //           page_name: AppLocalizations.of(context)
                //               .product_details_screen_return_policy,
                //         );
                //       }));
                //     }),
                is_logged_in.$ == true
                    ? Column(
                        children: [
                          ListTile(
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              title: Text(
                                AppLocalizations.of(context)
                                    .main_drawer_profile
                                    .toUpperCase(),
                                // style: TextStyle(
                                //     color: Theme.of(context)
                                //         .buttonTheme
                                //         .colorScheme
                                //         .primary,
                                //     fontSize: 13)
                              ),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Profile(show_back_button: true);
                                }));
                              }),
                          ListTile(
                              visualDensity:
                                  VisualDensity(horizontal: -4, vertical: -4),
                              title: Text(
                                AppLocalizations.of(context)
                                    .main_drawer_orders
                                    .toUpperCase(),
                              ),
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return OrderList(from_checkout: false);
                                }));
                              }),
                          // ListTile(
                          //     visualDensity:
                          //         VisualDensity(horizontal: -4, vertical: -4),
                          //     title: Text(
                          //         AppLocalizations.of(context)
                          //             .main_drawer_messages,
                          //         style: TextStyle(
                          //             color: Theme.of(context)
                          //                 .buttonTheme
                          //                 .colorScheme
                          //                 .primary,
                          //             fontSize: 13)),
                          //     onTap: () {
                          //       Navigator.push(context,
                          //           MaterialPageRoute(builder: (context) {
                          //         return MessengerList();
                          //       }));
                          //     }),
                          wallet_system_status.$
                              ? ListTile(
                                  visualDensity: VisualDensity(
                                      horizontal: -4,
                                      vertical: -4
                                  ),
                                  leading: Image.asset("assets/wallet.png",
                                      height: 16,
                                      color: Theme.of(context)
                                          .buttonTheme
                                          .colorScheme
                                          .primary),
                                  title: Text(
                                      AppLocalizations.of(context)
                                          .main_drawer_wallet,
                                      style: TextStyle(fontSize: 13)),
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
                //Divider(height: 24),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.0005,
                ),

                is_logged_in.$ == false
                    // ? ListTile(
                    //     visualDensity:
                    //         VisualDensity(horizontal: -4, vertical: -4),
                    //     // leading: Image.asset("assets/login.png",
                    //     //     height: 16,
                    //     //     color: Theme.of(context)
                    //     //         .buttonTheme
                    //     //         .colorScheme
                    //     //         .primary),
                    //     title: Text(
                    //         AppLocalizations.of(context).main_drawer_login,
                    //         style: TextStyle(fontSize: 13)),
                    //     onTap: () {
                    //       Navigator.push(context,
                    //           MaterialPageRoute(builder: (context) {
                    //         return Login();
                    //       }));
                    //     },
                    //   )
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    GestureDetector(
                      onTap:(){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: Container(
                        height: 42,
                        width: 80,
                        decoration: BoxDecoration(
                          color: MyTheme.secondary,
                          borderRadius: BorderRadius.circular(2.5),
                        ),
                        child:Center(
                          child: Text(
                           AppLocalizations.of(context).main_drawer_login,
                           style: TextStyle(
                               fontSize: 13,
                             color: MyTheme.white,
                               fontWeight: FontWeight.w600

                           )
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.04,
                    ),

                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Registration()));
                      },
                      child: Container(
                        height: 42,
                        width: 100,
                        decoration: BoxDecoration(
                          color: MyTheme.secondary,
                          borderRadius: BorderRadius.circular(2.5),
                        ),
                        child:Center(
                          child: Text(
                              "Register",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: MyTheme.white,
                                fontWeight: FontWeight.w600
                              )
                          ),
                        ),
                      ),
                    ),

                  ],
                )
                    : Container(),
                is_logged_in.$ == true
                    ? ListTile(
                        visualDensity:
                            VisualDensity(
                                horizontal: -4,
                                vertical: -4
                            ),
                        // leading: Image.asset("assets/logout.png",
                        //     height: 16,
                        //     color: Color.fromRGBO(153, 153, 153, 1)),
                        title: Text(
                          AppLocalizations.of(context)
                              .main_drawer_logout
                              .toUpperCase(),
                        ),
                        onTap: () {
                          onTapLogout(context);
                        })
                    : Container(),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.006,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    GestureDetector(
                      onTap: (){

                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.1,
                        decoration: BoxDecoration(
                          //image: DecorationImage(image: AssetImage("assets/youtube.png"))
                        ),
                        child: Image.asset("assets/facebook.png", fit: BoxFit.cover,),
                      ),
                    ),

                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),

                    GestureDetector(
                      onTap: (){

                      },
                   child: Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.1,
                      decoration: BoxDecoration(
                          //image: DecorationImage(image: AssetImage("assets/youtube.png"))
                      ),
                      child: Image.asset("assets/youtube.png", fit: BoxFit.cover,),
                    ),),

                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),

                    GestureDetector(
                      onTap: (){

                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.1,
                        decoration: BoxDecoration(
                          //image: DecorationImage(image: AssetImage("assets/youtube.png"))
                        ),
                        child: Image.asset("assets/instagram.png", fit: BoxFit.cover,),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
