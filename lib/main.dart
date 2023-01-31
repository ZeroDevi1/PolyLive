import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:poly_live/app/modules/favorite/controller.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/routes/app_pages.dart';
import 'common/utils/messages.dart';
import 'common/utils/pref_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PrefUtil.prefs = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FavoriteProvider(context),
          lazy: false,
        ),
      ],
      child: GetMaterialApp(
        title: "Application",
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        translations: Messages(),
        locale: ui.window.locale,
        fallbackLocale: const Locale('en', 'US'),
      ),
    ),
  );
}
