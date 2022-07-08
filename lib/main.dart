import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:weapon/config/route_config.dart';
import 'package:weapon/custom/custom_loading_widget.dart';
import 'package:weapon/custom/custom_toast_widget.dart';
import 'package:weapon/utils/database_util.dart';

Future<void> main() async {
  //确保 WidgetsBinding.instance 后续使用没有问题
  WidgetsFlutterBinding.ensureInitialized();
  await DataBaseUtil.initDB();
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

    // LeanCloudUtil.initSDK();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        initialRoute: RouteConfig.webLand,
        debugShowCheckedModeBanner: false,
        getPages: RouteConfig.getPages,
        // home: WebLandView(),
        theme: ThemeData(
          primarySwatch: Colors.indigo,
            appBarTheme: AppBarTheme.of(context).copyWith(
              brightness: Brightness.light,
            )
        ),
        navigatorObservers: [FlutterSmartDialog.observer],
        builder: FlutterSmartDialog.init(
          toastBuilder: (String msg, AlignmentGeometry alignment) {
            return CustomToastWidget(msg: msg, alignment: alignment);
          },
          loadingBuilder: (String msg, Color background) {
            return CustomLoadingWidget(msg: msg, background: background);
          },
        ),
        // home: MainView()
    );
  }
}
