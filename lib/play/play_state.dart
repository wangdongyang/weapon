import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:weapon/audio/audio_play_page.dart';
import 'package:weapon/model/history_po.dart';
import 'package:weapon/model/lyric.dart';
import 'package:weapon/play/lyric/lyric_view.dart';
import 'package:weapon/utils/lyric_util.dart';

class PlayState {
  // HistoryPo? historyPo;
  String? playId;
  String? picUrl;
  String? name;
  String? artist;
  late AudioSource source;
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

  String get sourceStr => source.toString().split(".").last;

  PlayState() {
    duration = const Duration();
    position = const Duration();

    source = AudioSource.netease;

    dragEndDuration = const Duration(milliseconds: 1000);
    curPositionController = StreamController<String>.broadcast();
    curPositionStream = curPositionController.stream;

    // lyrics = LyricUtil.formatLyric(historyPo?.lyricUrl ?? "");
    // lyricWidget = LyricView(lyrics, 0);
  }
}
