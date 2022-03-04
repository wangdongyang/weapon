import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:weapon/config/route_config.dart';
import 'package:weapon/custom/custom_loading_widget.dart';
import 'package:weapon/custom/custom_toast_widget.dart';
import 'package:weapon/utils/leancloud_util.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    LeanCloudUtil.initSDK();
  }


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: RouteConfig.main,
      debugShowCheckedModeBanner: false,
      getPages: RouteConfig.getPages,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(
        toastBuilder: (String msg, AlignmentGeometry alignment) {
          return CustomToastWidget(msg: msg, alignment: alignment);
        },
        loadingBuilder: (String msg, Color background) {
          return CustomLoadingWidget(msg: msg, background: background);
        },
        // builder: _builder,
      ),
    );
  }
}
