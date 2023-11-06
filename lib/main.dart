import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:resume/helper/bug_reporting/shake_service.dart';

import 'package:resume/model/state.dart';
import 'package:resume/router/auto_route.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid || Platform.isIOS) {
    ShakeService(_appRouter);
  }
  Animate.restartOnHotReload = true;
  runApp(MyApp());
}

final _appRouter = AppRouter();

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StateClass(),
      child: AdaptiveTheme(
        light: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            colorSchemeSeed: Colors.blue,
            inputDecorationTheme: InputDecorationTheme()
                .copyWith(labelStyle: TextStyle(height: 0.5))),
        dark: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorSchemeSeed: Colors.blue,
            inputDecorationTheme: InputDecorationTheme()
                .copyWith(labelStyle: TextStyle(height: 0.5))),
        initial: AdaptiveThemeMode.light,
        builder: (theme, darktheme) => MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: _appRouter.config(),
          theme: theme,
          darkTheme: darktheme,
        ),
      ),
    );
  }
}
