import 'package:firebase_core/firebase_core.dart';
import 'package:kirei/firebase_options.dart';
import 'package:kirei/helpers/auth_helper.dart';
import 'package:kirei/other_config.dart';
import 'package:kirei/providers/cart_count_update.dart';
import 'package:kirei/providers/category_passing_controller.dart';
import 'package:kirei/providers/version_change.dart';
import 'package:kirei/screens/routes.dart';
import 'package:kirei/services/push_notification_service.dart';
import 'package:kirei/theme/appThemes.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kirei/screens/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_value/shared_value.dart';
import 'package:kirei/helpers/shared_value_helper.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';
import 'app_config.dart';
import 'package:one_context/one_context.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:kirei/providers/locale_provider.dart';
import 'lang_config.dart';
import 'screens/recomendation_pages/recommendetion_controller.dart';

SharedPreferences sharedPreferences;
Future<void> _launchUrl(Uri url) async {
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}


main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "KireiBD",
    options: DefaultFirebaseOptions.currentPlatform
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Upgrader.clearSavedSettings();
  sharedPreferences = await SharedPreferences.getInstance();
  print("app_mobile_language.1isEmpty${app_mobile_language.$.isEmpty}");
  // AddonsHelper().setAddonsData();
  // BusinessSettingHelper().setBusinessSettingData();
  app_language.load();
  app_mobile_language.load();
  app_language_rtl.load();

  access_token.load().whenComplete(() {
    AuthHelper().fetch_and_set();
  });

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));

  runApp(
    SharedValue.wrapApp(
      MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    if (OtherConfig.USE_PUSH_NOTIFICATION) {
      Future.delayed(Duration(milliseconds: 100), () async {
        PushNotificationService().initialise();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
          ChangeNotifierProvider(create: (_) => CartCountUpdate()),
          ChangeNotifierProvider(create: (_) => CategoryPassingController()),
          ChangeNotifierProvider(create: (_) => VersionChange()),
          ChangeNotifierProvider(create: (_) => RecommendationController()),
        ],
        child: Consumer<LocaleProvider>(builder: (context, provider, snapshot) {
          return DynamicTheme(
              themeCollection: themeCollection,
              defaultThemeId: AppThemes.Default,
              builder: (context, theme) {
                return Container(
                    child: MaterialApp.router(
                      routeInformationParser: AppRoutes().router.routeInformationParser,
                      routerDelegate: AppRoutes().router.routerDelegate,
                  builder: OneContext().builder,
                 // navigatorKey: OneContext().navigator.key,
                  title: AppConfig.app_name,

                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                    primaryIconTheme: IconThemeData(color: Colors.white),
                    colorScheme: ColorScheme.light(
                      background: Colors.white70,
                      primary: Colors.pink,
                      secondary: Colors.deepOrangeAccent,
                    ),

                    buttonTheme: ButtonThemeData(
                        colorScheme: ColorScheme.light(
                      primary: Colors.red[900],
                      background: Colors.red[600],
                      secondaryVariant: Colors.pink,
                      secondary: Colors.black,
                    )),

                    // Set your global font family here
                    textTheme: GoogleFonts.openSansTextTheme(),

                    // Other theme configurations...
                  ),
                  localizationsDelegates: [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    AppLocalizations.delegate,
                  ],
                  locale: provider.locale,

                  //home: Splash(),
                  // home: UpgradeAlert(
                  //     upgrader: Upgrader(
                  //      onUpdate: (){
                  //        _launchUrl(Uri.parse('https://play.google.com/store/apps/details?id=com.thetork.kirei&hl=en_US'));
                  //      },
                  //       showIgnore: false,
                  //       //showLater: false,
                  //     ),
                  //     child: Splash()
                  // ),
                  //home: Main(),
                ));
              });
        }));
  }
}