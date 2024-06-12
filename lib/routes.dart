
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kirei/data_model/product_details_response.dart';
import 'package:kirei/screens/filter.dart';
import 'package:kirei/screens/main.dart';
import 'package:kirei/screens/product_details.dart';
import 'package:kirei/screens/splash.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _launchUrl(Uri url) async {
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}

class AppRoutes{

  final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => UpgradeAlert(
            upgrader: Upgrader(
              onUpdate: (){
                _launchUrl(Uri.parse('https://play.google.com/store/apps/details?id=com.thetork.kirei&hl=en_US'));
              },
              showIgnore: false,
              //showLater: false,
            ),
            child: Splash()
        ),
      ),
      GoRoute(
        path: '/bottomNav',
        builder: (context, state) => Main(),
      ),
      GoRoute(
        path: '/filter',
        builder: (context, state) => Main(pageIndex: 1,),
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) {
          final String id = state.params['id'];
          return ProductDetails(slug: id);
        },
      ),
    ],
  );

}