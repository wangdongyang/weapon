import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:weapon/model/history_po.dart';
import 'package:weapon/play/play_state.dart';
import 'package:weapon/utils/audio_player_util.dart';
import 'package:weapon/utils/lyric_util.dart';

import 'lyric/lyric_view.dart';

class PlayController extends GetxController {
  late PlayState state;

  initState(HistoryPo? historyPo) {
    print('initState : ${historyPo?.name}; url = ${historyPo?.playUrl}');
    state.historyPo = historyPo;
    state.lyrics = LyricUtil.formatLyric(historyPo?.lyricUrl ?? "");
    state.lyricWidget = LyricView(state.lyrics, 0);
    state.name = historyPo?.name ?? "";
    state.picUrl = historyPo?.picUrl ?? "";
    state.artist = historyPo?.artist.map((e) => e.name).toList().join(",") ?? "";
    state.playerState = AudioPlayerUtil.instance.playerState;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    state = PlayState();
    initAudioPlayer();
  }

  initAudioPlayer() {
    AudioPlayerUtil.instance.durationSubscription.onData((data) {
      state.duration = data;
      update();
    });

    AudioPlayerUtil.instance.positionSubscription.onData((data) {
      print("initAudioPlayer positionSubscription = $data");
      state.position = data;
      update();
    });

    AudioPlayerUtil.instance.playerCompleteSubscription.onData((data) {
      state.position = const Duration();
      update();
    });

    AudioPlayerUtil.instance.playerErrorSubscription.onData((data) {
      state.duration = const Duration(seconds: 0);
      state.position = const Duration(seconds: 0);
    });

    AudioPlayerUtil.instance.playerStateSubscription.onData((data) {
      update();
    });
  }

  play() async {
    print('PlayController->play' + (state.historyPo?.playUrl ?? ""));

    if (state.historyPo == null) return;
    String url = state.historyPo?.playUrl ?? "";
    if (url.isEmpty) return;

    final playPosition = (state.position.inMilliseconds > 0 &&
            state.position.inMilliseconds < state.duration.inMilliseconds)
        ? state.position
        : const Duration();

    AudioPlayerUtil.instance.play(url, playPosition);
    // state.audioPlayer.setPlaybackRate(1.0);
  }

  previous() {}

  next() {}
}
