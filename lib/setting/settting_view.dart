import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingView extends StatelessWidget {
  SettingView({Key? key}) : super(key: key);

  //创建Dark ThemeData对象
  final ThemeData appDarkThemeData = ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.red,
      // 主要部分背景颜色（导航和tabBar等）
      scaffoldBackgroundColor: Colors.red,
      //Scaffold的背景颜色。典型Material应用程序或应用程序内页面的背景颜色
      textTheme: const TextTheme(
          headline1: TextStyle(color: Colors.yellow, fontSize: 15)),
      appBarTheme:
          const AppBarTheme(iconTheme: IconThemeData(color: Colors.yellow)));

//创建light ThemeData对象
  final ThemeData appLightThemeData = ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.white,
      // 主要部分背景颜色（导航和tabBar等）
      scaffoldBackgroundColor: Colors.white,
      //Scaffold的背景颜色。典型Material应用程序或应用程序内页面的背景颜色
      textTheme: const TextTheme(
          headline1: TextStyle(color: Colors.blue, fontSize: 15)),
      appBarTheme:
          const AppBarTheme(iconTheme: IconThemeData(color: Colors.black)));

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
          child: TextButton(
        onPressed: () {
          //直接设置Theme
          Get.changeTheme(
              Get.isDarkMode ? appLightThemeData : appDarkThemeData);
          //设置ThemeMode
          Get.changeThemeMode(
              Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
          //这里要设置个延迟,在调用切换主题后并不能立刻生效,会有点延迟,
          // 如果不设置延迟会导致取的还是上个主题状态
          Future.delayed(Duration(milliseconds: 250), () {
            //强制触发 build
            Get.forceAppUpdate();
            if (Get.isDarkMode) {
              print("转换后 darkMode");
            } else {
              print("转换后 lightMode");
            }
          });
        },
        child: Text(
          "更换主题",
          style: Get.textTheme.headline1, //这里有个问题,就是主题切换,这里的Text并不会更新
        ),
      )),
    );
  }
}
