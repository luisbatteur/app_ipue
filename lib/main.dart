import 'package:app_ipue/utilities/styles_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:app_ipue/pages/SplashMapPage.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();

  runApp(const GetMaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness:
                Brightness.dark) /* set Status bar icon color in iOS. */
        );
    return MaterialApp(
      title: 'IPUE',
      theme: ThemeData(
        fontFamily: "Inter",
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: IpueColors.cPrimario),
          bodySmall: TextStyle(color: IpueColors.cSecundario),
        ),
      ),
      home: const SplashMapPage(),
    );
  }
}
