import 'dart:convert';

import 'package:crypto_flutter/models/app_config.dart';
import 'package:crypto_flutter/pages/homepage.dart';
import 'package:crypto_flutter/services/http_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // makes sure that the application has been setup properly
  await loadConfig();
  regiterHTTPService();
  runApp(const MyApp());
}

Future<void> loadConfig() async {
  String _configContent =
      await rootBundle.loadString("assets/config/main.json");
  Map _configData = jsonDecode(_configContent);
  GetIt.instance.registerSingleton<AppConfig>(
      AppConfig(COIN_API_BASE_URL: _configData["COIN_API_BASE_URL"]));
}

void regiterHTTPService() {
  GetIt.instance.registerSingleton<HTTPService>(
    HTTPService(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto App',
      theme: ThemeData(
          primarySwatch: Colors.lightGreen,
          scaffoldBackgroundColor: Colors.blueGrey),
      home: Homepage(),
    );
  }
}
