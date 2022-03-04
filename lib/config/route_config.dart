import 'package:get/get.dart';
import 'package:weapon/main/main_controller.dart';
import 'package:weapon/main/main_state.dart';
import 'package:weapon/main/main_view.dart';
import 'package:weapon/play/play_view.dart';

class RouteConfig {
  ///主页面
  static const String main = "/";

  static const String play = "/play";

  ///别名映射页面
  static final List<GetPage> getPages = [
    GetPage(
      name: main,
      page: () => MainView(),
    ),
    GetPage(
      name: play,
      page: () => PlayView(),
    ),
  ];
}
