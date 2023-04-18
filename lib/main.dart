import 'package:app_ipue/pages/mio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
        fontFamily: "Roboto",
      ),
      // home: const SplashPage(),
      home: const SplashMapPage(),
      // home: const Mio(),
      builder: EasyLoading.init(),
    );
  }
}
