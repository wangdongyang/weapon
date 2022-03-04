import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:weapon/model/history_po.dart';
import 'package:weapon/model/lyric.dart';
import 'package:weapon/play/lyric/lyric_view.dart';
import 'package:weapon/utils/lyric_util.dart';

class PlayState {
  HistoryPo? historyPo;
  String? picUrl;
  String? name;
  String? artist;
  PlayerState? playerState;
  AnimationController? lyricOffsetYController;
  Timer? dragEndTimer;
  late Function dragEndFunc;
  late Duration dragEndDuration = const Duration(milliseconds: 1000);
  LyricView? lyricWidget;
  List<Lyric> lyrics = [];
  late StreamController<String> curPositionController;
  late Stream<String> curPositionStream;
  late Duration duration = const Duration();
  late Duration position = const Duration();


  PlayState() {
    duration = const Duration();
    position = const Duration();

    dragEndDuration = const Duration(milliseconds: 1000);
    curPositionController = StreamController<String>.broadcast();
    curPositionStream = curPositionController.stream;

    // lyrics = LyricUtil.formatLyric(historyPo?.lyricUrl ?? "");
    // lyricWidget = LyricView(lyrics, 0);
  }
}
