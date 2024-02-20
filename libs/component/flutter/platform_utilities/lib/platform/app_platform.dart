import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/date_symbol_data_local.dart';

class AppPlatform {
  static String appDataPath = '';

  static var isMobile = Platform.isAndroid || Platform.isIOS;
  static var isDarkMode = false;

  static Future<void> init() async {
    appDataPath = (await getApplicationDocumentsDirectory()).path;

    // initialize intl package localized date formats
    await initializeDateFormatting();
  }

  static initOnBuild(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    isDarkMode = brightness == Brightness.dark;
  }
}
