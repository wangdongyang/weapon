import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:weapon/config/api_config.dart';
import 'package:weapon/model/history_po.dart';
import 'package:weapon/model/song_detail.dart';
import 'package:weapon/play/play_state.dart';
import 'package:weapon/utils/audio_player_util.dart';
import 'package:weapon/utils/auth_util.dart';
import 'package:weapon/utils/lyric_util.dart';

import 'lyric/lyric_view.dart';

class PlayController extends GetxController {
  PlayState state = PlayState();

  late PlayerMode mode;
  late AudioPlayer audioPlayer;

  initState(HistoryPo? historyPo) {
    state.historyPo = historyPo;
    state.lyrics = LyricUtil.formatLyric(historyPo?.lyricUrl ?? "");
    state.lyricWidget = LyricView(state.lyrics, 0);
    state.name = historyPo?.name ?? "";
    state.picUrl = historyPo?.picUrl ?? "";
    state.artist = historyPo?.artist.map((e) => e.name).toList().join(",") ?? "";

    update();
  }

  @override
  void onInit() {
    super.onInit();
    initAudioPlayer();
  }

  initAudioPlayer() {
    mode = PlayerMode.MEDIA_PLAYER;
    audioPlayer = AudioPlayer(mode: mode);
    state.playerState = audioPlayer.state;

    audioPlayer.onDurationChanged.listen((duration) {
      state.duration = duration;
      update();
    });

    //监听进度
    audioPlayer.onAudioPositionChanged.listen((position) {
      state.position = position;
      update();
    });

    //播放完成
    audioPlayer.onPlayerCompletion.listen((event) {
      state.position = const Duration();
      update();
    });

    //监听报错
    audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      state.duration = const Duration(seconds: 0);
      state.position = const Duration(seconds: 0);
      update();
    });

    //播放状态改变
    audioPlayer.onPlayerStateChanged.listen((playerState) {
      state.playerState = playerState;
      update();
    });
  }

  play() async {
    print('PlayController->play->url = ' + (state.historyPo?.playUrl ?? ""));
    if (state.historyPo == null) return;
    String songId = state.historyPo!.playId;
    var dio = Dio();
    Map<String, dynamic> header = AuthUtil.getHeader(Api.music);
    Map<String, dynamic> param = {"item_id": songId, "site": state.historyPo!.source};
    dio.options.headers = header;
    final response = await dio.get(Api.music, queryParameters: param);
    SongDetail detail = SongDetail.fromJson(jsonDecode(response.toString()));

    String url = detail.url ?? "";
    if (url.isEmpty) return;

    final playPosition = (state.position.inMilliseconds > 0 &&
            state.position.inMilliseconds < state.duration.inMilliseconds)
        ? state.position
        : const Duration();

    if (url.isEmpty) {
      print("url 为空");
      return;
    }
    if (audioPlayer.state == PlayerState.PLAYING) {
      final result = await audioPlayer.pause();
      if (result == 1) {
        print('pause succes');
      }
      return;
    }
    final result =
    await audioPlayer.play(url, position: playPosition);
    if (result == 1) {
      print('play succes');
    }
  }

  previous() {}

  next() {}
}
