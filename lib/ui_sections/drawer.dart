import 'dart:math';

import 'package:kirei/data_model/category_response.dart';
import 'package:kirei/my_theme.dart';
import 'package:kirei/providers/cart_count_update.dart';
import 'package:kirei/providers/category_passing_controller.dart';
import 'package:kirei/providers/version_change.dart';
import 'package:kirei/repositories/category_repository.dart';
import 'package:kirei/screens/appointment.dart';
import 'package:kirei/screens/beauty_tips.dart';
import 'package:kirei/screens/common_webview_screen.dart';
import 'package:kirei/screens/newsfeed.dart';
import 'package:kirei/screens/registration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:kirei/screens/main.dart';
import 'package:kirei/screens/order_list.dart';

import 'package:kirei/screens/login.dart';
import 'package:kirei/screens/wallet.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:kirei/helpers/auth_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return Main();
    }), (route) => false);
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
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
                      backgroundImage:
                          avatar_original.$ != null ? NetworkImage("${avatar_original.$}") : AssetImage('assets/placeholder.png') //TODO:change the avatar
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
                    title: Text('New Arrivals'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 13,
                        )),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return Main(pageIndex: 1,);
                          }));
                    }),
                Consumer<CategoryPassingController>(
                    builder: (widget, value, child) {
                      return ExpansionTile(
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
                              ? Padding(
                            padding:  EdgeInsets.only(left: 8.0),
                            child: ExpansionTile(
                              title: GestureDetector(
                                  onTap: (){
                                    value.setCategoryKey(category.slug);
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                          return Main(pageIndex: 1,);
                                        }));
                                  },
                                  child: Text(category.name)
                              ),
                              children: category.children.map((child) {
                                return Padding(
                                  padding:  EdgeInsets.only(left: 8.0),
                                  child: ListTile(
                                    onTap: () {
                                      value.setCategoryKey(child.slug);
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                            return Main(pageIndex: 1,);
                                          }));
                                    },
                                    visualDensity:
                                    VisualDensity(horizontal: -4, vertical: -4),
                                    title: Text(child.name),
                                  ),
                                );
                              }).toList(),
                            ),
                          )
                              : Padding(
                            padding:  EdgeInsets.only( left: 8.0),
                            child: ListTile(
                              onTap: () {
                                value.setCategoryKey(category.slug);
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return Main(pageIndex: 1,);
                                    }));
                              },
                              visualDensity:
                              VisualDensity(horizontal: -4, vertical: -4),
                              title: Text(category.name),
                            ),
                          );
                        }).toList(),
                      );
                    }
                ),

                ListTile(
                    visualDensity:
                    VisualDensity(horizontal: -4, vertical: -4),
                    title: Row(
                      children: [
                        Text('BRANDS',
                            style: TextStyle(fontSize: 13)),
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
                              child: Text("Top!",
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
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return CommonWebviewScreen(
                              url: "https://kireibd.com/brands?type=app",
                              page_name: "Brands",
                            );
                          }));
                    }),

                ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
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

                ListTile(
                    visualDensity:
                    VisualDensity(horizontal: -4, vertical: -4),
                    title: Text('PERSONAL RECOMMENDATION',
                        style: TextStyle(fontSize: 13)),
                    onTap: () {
                      if(is_logged_in.$){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return CommonWebviewScreen(
                              url: "https://kireibd.com/personal-recommendation/skincare-recommendation?user_id=${user_id.$}&type=app",
                              page_name: "Personal Recommendation",
                            );
                          }));
                      }else{
                        Navigator.push(context, MaterialPageRoute(builder: (_)=> Login()));
                      }
                    }),

                ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
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
                    visualDensity:
                    VisualDensity(horizontal: -4, vertical: -4),
                    title: Text('BLOG',
                        style: TextStyle(fontSize: 13)),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return CommonWebviewScreen(
                              url: "https://kireibd.com/blogs?type=app",
                              page_name: "Blogs",
                            );
                          }));
                    }),

                ExpansionTile(
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
                      Padding(
                        padding:  EdgeInsets.only( left: 8.0),
                        child: Column(
                          children: [
                            ListTile(
                                visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
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
                                title: Text('Returns & Refunds',
                                    style: TextStyle(fontSize: 13)),
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                        return CommonWebviewScreen(
                                          url:
                                          "https://kireibd.com/return-refund?type=app",
                                          page_name: 'Returns & Refunds',
                                        );
                                      }));
                                }),
                            ListTile(
                                visualDensity:
                                VisualDensity(horizontal: -4, vertical: -4),
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
                          ],
                        ),
                      )
                    ]),
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
                        ),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return Main(pageIndex: 3,);
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

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.0005,
                ),

                is_logged_in.$ == false
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
                    ? Consumer<CartCountUpdate>(
                    builder: (widget, value, child) {
                      return ListTile(
                          visualDensity:
                          VisualDensity(
                              horizontal: -4,
                              vertical: -4
                          ),
                          title: Text(
                            AppLocalizations.of(context)
                                .main_drawer_logout
                                .toUpperCase(),
                          ),
                          onTap: () {
                            onTapLogout(context);
                            value.getReset();
                          });
                    }
                )
                    : Container(),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.006,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    GestureDetector(
                      onTap: (){
                        _launchUrl(Uri.parse('https://www.facebook.com/jbeautybyKirei'));
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.1,
                        decoration: BoxDecoration(
                        ),
                        child: Image.asset("assets/facebook.png", fit: BoxFit.cover,),
                      ),
                    ),

                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),

                    GestureDetector(
                      onTap: (){
                        _launchUrl(Uri.parse('https://www.youtube.com/channel/UCfcO3vgVRLyqcIoAl8AX8Ew'));
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.1,
                        decoration: BoxDecoration(
                        ),
                        child: Image.asset("assets/youtube.png", fit: BoxFit.cover,),
                      ),),

                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),

                    GestureDetector(
                      onTap: (){
                        _launchUrl(Uri.parse('https://www.instagram.com/accounts/login/?next=%2Fjbeauty_kirei%2F'));
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.1,
                        decoration: BoxDecoration(
                        ),
                        child: Image.asset("assets/instagram.png", fit: BoxFit.cover,),
                      ),
                    ),
                  ],
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.015,
                ),

               Consumer<VersionChange>(
                   builder: (context, value, child){
                     return Text("version: ${value.latestVersion}",
                       style: TextStyle(
                           fontWeight: FontWeight.w500
                       ),
                     );
               }),

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
