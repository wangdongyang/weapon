import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weapon/auto_ui.dart';

class SettingView extends StatelessWidget {
  SettingView({Key? key}) : super(key: key);
  ScrollController scrollController = ScrollController();

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
      color: const Color(0xffF6F8F9),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: GridView.builder(
          // padding: EdgeInsets.all(20.dp),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          controller: scrollController,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              mainAxisSpacing: 1.dp,
              crossAxisSpacing: 1.dp,
              childAspectRatio: 1.4),
          itemBuilder: (BuildContext context, int index) {
            if (index == 1) {
              return _darkWidget();
            }
            if (index == 2) {
              return _fontItemWidget();
            }
            if (index == 3) {
              return _font2ItemWidget();
            }
            return _itemWidget();
          },
          itemCount: 4,
        ),
      ),
    );
  }

  Widget _itemWidget() {
    return Container(
      color: const Color(0xffffffff),
      height: double.infinity,
      alignment: Alignment.center,
      child: Text(
        "LIGHT",
        maxLines: 4,
        textAlign: TextAlign.start,
        style: TextStyle(
            fontSize: 25.sp,
            fontWeight: FontWeight.w300,
            color: const Color(0xFF9C9C9C),),
    ),);
  }

  Widget _darkWidget() {
    return Container(
      color: const Color(0xffffffff),
      height: double.infinity,
      alignment: Alignment.center,
      child: Text(
        "DARK",
        maxLines: 4,
        textAlign: TextAlign.start,
        style: TextStyle(
            fontSize: 25.sp,
            color: const Color(0xFF9C9C9C), fontWeight: FontWeight.w300),
      ),
    );
  }

  Widget _fontItemWidget() {
    return Container(
      color: const Color(0xffffffff),
      height: double.infinity,
      alignment: Alignment.center,
      child: Text(
        "Aa",
        maxLines: 4,
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 33.sp,
          color: const Color(0xFF9C9C9C),
          fontFamily: 'ZCOOLXiaoWei',
          letterSpacing: 1.1,
          wordSpacing: 1.2,
          height: 1.4,
          fontStyle: FontStyle.normal,),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _font2ItemWidget() {
    return Container(
      color: const Color(0xffffffff),
      height: double.infinity,
      alignment: Alignment.center,
      child: Text(
        "Aa",
        textAlign: TextAlign.start,
        style: TextStyle(
          fontSize: 33.sp,
          color: const Color(0xFF9C9C9C),
          fontFamily: 'JasonHandwriting2',
          letterSpacing: 1.1,
          wordSpacing: 1.2,
          height: 1.4,),
      ),
    );
  }

  button() {
    return TextButton(
      onPressed: () {
        //直接设置Theme
        Get.changeTheme(Get.isDarkMode ? appLightThemeData : appDarkThemeData);
        //设置ThemeMode
        Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
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
    );
  }
}
