import 'package:active_ecommerce_flutter/theme/appThemes.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';

class DynamicThemesExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return DynamicTheme(
        themeCollection: themeCollection,
        defaultThemeId: AppThemes.LightBlue,
        builder: (context, theme) {
          return Container(
            child: MaterialApp(

              theme: theme,
              home: HomePage(),
            ),
          );
        });
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int dropdownValue = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    dropdownValue = DynamicTheme.of(context).themeId;
    return Scaffold(
      appBar: AppBar(
        title: Text("Kirei theme"),
      ),
      body: Center(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 12),
            child: Text('Select your theme here:'),
          ),
          DropdownButton(
              icon: Icon(Icons.arrow_downward),
              value: dropdownValue,
              items: [
                DropdownMenuItem(
                  value: AppThemes.Default,
                  child: Text(AppThemes.toStr(AppThemes.Default)),
                ),
                DropdownMenuItem(
                  value: AppThemes.Kirei1,
                  child: Text(AppThemes.toStr(AppThemes.Kirei1)),
                ),
                DropdownMenuItem(
                  value: AppThemes.Kirei2,
                  child: Text(AppThemes.toStr(AppThemes.Kirei2)),
                ),
                DropdownMenuItem(
                  value: AppThemes.LightBlue,
                  child: Text(AppThemes.toStr(AppThemes.LightBlue)),
                ),
                DropdownMenuItem(
                  value: AppThemes.LightRed,
                  child: Text(AppThemes.toStr(AppThemes.LightRed)),
                )
              ],
              onChanged: (dynamic themeId) async {
                await DynamicTheme.of(context).setTheme(themeId);

                setState(() {
                  dropdownValue = themeId;
                });
                Restart.restartApp();
              }),

        ],
      )),
    );
  }
}
