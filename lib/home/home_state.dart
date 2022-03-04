import 'package:flutter/material.dart';
import 'package:flutter_toolkit_easy/flutter_toolkit.dart';
import 'package:weapon/audio/audio_play_page.dart';
import 'package:weapon/bookmark/bookmark_page.dart';
import 'package:weapon/favorite/favorite_page.dart';
import 'package:weapon/model/btn_info.dart';
// import 'package:flutter_use/module/example/view.dart';
// import 'package:flutter_use/module/function/view.dart';
// import 'package:flutter_use/module/setting/view.dart';

class HomeState {
  ///选择index
  late int selectedIndex;

  ///控制是否展开
  late bool isUnfold;

  ///是否缩放
  late bool isScale;

  ///分类按钮数据源
  late List<BtnInfo> list;

  ///Navigation的item信息
  late List<BtnInfo> itemList;

  ///PageView页面
  late List<Widget> pageList;
  late PageController pageController;

  HomeState() {
    //初始化index
    selectedIndex = 0;
    //默认不展开
    isUnfold = false;
    //默认不缩放
    isScale = false;
    //PageView页面
    pageList = [
      KeepAlivePage(const FavoritePage()),
      KeepAlivePage(const BookMarkPage()),
      KeepAlivePage(const AudioPlayPage()),
    ];
    //item栏目
    itemList = [
      BtnInfo(
        title: "首页",
        icon: "home",
      ),
      BtnInfo(
        title: "最近",
        icon: "recent",
      ),
      BtnInfo(
        title: "收藏",
        icon: "favorite",
      ),
    ];
    //页面控制器
    pageController = PageController();
  }
}
