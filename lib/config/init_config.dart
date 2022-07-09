import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weapon/auto_ui.dart';
import 'package:weapon/utils/window_size.dart';
import 'package:window_size/window_size.dart' as window_size;

class InitConfig {
  InitConfig.initApp(BuildContext? context) {
    //初始化窗口
    initWindow();

    //界面适配
    AutoUi.init();
  }
}

//窗口设置只能放大，不能缩小，很奇怪
void initWindow({double scale: 1.0}) async {
  if (!WindowSize.jumpPlatform()) {
    return;
  }

  // 获取窗口信息，然后设置窗口信息
  var window = await window_size.getWindowInfo();
  if (window.screen == null) {
    return;
  }
  final screenFrame = window.screen!.visibleFrame;
  final width = 1100.0.dp * scale;
  final height = 700.0.dp * scale;
  final left = ((screenFrame.width - width) / 2).roundToDouble();
  final top = ((screenFrame.height - height) / 3).roundToDouble();
  final frame = Rect.fromLTWH(left, top, width, height);
  // //设置窗口信息
  window_size.setWindowFrame(frame);
  //设置窗口顶部标题
  window_size.setWindowTitle('简悦');
  //限制最大最小窗口大小
  window_size.setWindowMinSize(Size(width, height));
}