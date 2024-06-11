
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kirei/screens/product_details.dart';
import 'package:kirei/screens/splash.dart';

class AppRoutes{
  final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return Splash();
        },
        routes: [
          GoRoute(
            path: 'details',
            builder: (BuildContext context, GoRouterState state) {
              return ProductDetails();
            },
          ),
        ],
      ),
    ],
  );
}