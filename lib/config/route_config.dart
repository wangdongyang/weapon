import 'package:get/get.dart';
import 'package:weapon/home/home_view.dart';
import 'package:weapon/home/songs_view.dart';
import 'package:weapon/main/main_controller.dart';
import 'package:weapon/main/main_state.dart';
import 'package:weapon/main/main_view.dart';
import 'package:weapon/play/play_view.dart';

class RouteConfig {
  ///主页面
  static const String main = "/";

  static const String play = "/play";
  static const String home = "/home";

  static const String songs = "/home/songs";

  ///别名映射页面
  static final List<GetPage> getPages = [
    GetPage(name: main, page: () => MainView(), children: [
      GetPage(
        name: play,
        page: () => PlayView(),
      ),
      GetPage(name: home, page: () => HomeView(), children: [
        GetPage(
          name: songs,
          page: () => SongsView(),
        ),
      ]),
    ]),
  ];
}
