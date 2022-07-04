import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:weapon/config/api_config.dart';
import 'package:weapon/model/history_po.dart';
import 'package:weapon/model/song_detail.dart';
import 'package:weapon/model/song_list_item.dart';
import 'package:weapon/model/song_rank_model.dart';
import 'package:weapon/play/play_state.dart';
import 'package:weapon/search/search_state.dart';
import 'package:weapon/utils/audio_player_util.dart';
import 'package:weapon/utils/auth_util.dart';
import 'package:weapon/utils/lyric_util.dart';

import 'lyric_view.dart';

class PlayController extends GetxController {
  PlayState state = PlayState();

  late PlayerMode mode;
  late AudioPlayer audioPlayer;
  late List playItems = [];
  late int playIndex = 0;

  initState(List<HistoryPo>? histories, int index) {
    if (histories == null || histories.isEmpty) return;
    playItems = histories;
    playIndex = index;
    HistoryPo historyPo = histories[index];
    if (state.playId == historyPo.playId) return;
    state.playId = historyPo.playId;
    state.source = historyPo.sourceType;
    state.lyrics = LyricUtil.formatLyric(historyPo.lyricUrl);
    state.lyricWidget = LyricView(state.lyrics, 0);
    state.name = historyPo.name;
    state.picUrl = historyPo.picUrl;
    state.artist = historyPo.artist.map((e) => e.name).toList().join(",");
    state.duration = const Duration();
    state.position = const Duration();

    play();
    update();
  }

  initSongListItem(
      AudioSource source, List<SongListItem>? songs, int index) async {
    if (songs == null || songs.isEmpty) return;
    playItems = songs;
    playIndex = index;

    SongListItem item = songs[index];
    state.source = source;
    // print(source);
    String? id = item.id;
    if (state.playId == id) return;

    if (item.lyric == null) {
      var dio = Dio();
      Map<String, dynamic> header = AuthUtil.getHeader(Api.lyric);
      dio.options.headers = header;
      Map<String, dynamic> lyricParam = {
        "lyric_id": id,
        "source": state.sourceStr,
        "type": "lyric"
      };
      final lyricResponse =
          await dio.get(Api.lyric, queryParameters: lyricParam);
      var lyricMap = jsonDecode(lyricResponse.toString());
      item.lyric = lyricMap;
      // print(lyricMap);
    }

    state.playId = id;
    state.lyrics = LyricUtil.formatLyric(item.lyric["lyric"]);
    state.lyricWidget = LyricView(state.lyrics, 0);
    state.name = item.name;
    state.picUrl = item.picUrl;
    state.artist = item.artist.map((e) => e.name).toList().join(",");
    state.duration = const Duration();
    state.position = const Duration();
    play();
    update();
  }

  initRankSong(
      AudioSource source, List<SongRankModel>? ranks, int index) async {
    if (ranks == null || ranks.isEmpty) return;
    playItems = ranks;
    playIndex = index;

    SongRankModel? rank = ranks[index];
    state.source = source;
    String? id = rank.hash;
    if (state.playId == id) return;
    if (rank.lyric == null) {
      var dio = Dio();
      Map<String, dynamic> header = AuthUtil.getHeader(Api.lyric);
      dio.options.headers = header;
      Map<String, dynamic> lyricParam = {
        "lyric_id": id,
        "source": state.sourceStr,
        "type": "lyric"
      };
      final lyricResponse =
          await dio.get(Api.lyric, queryParameters: lyricParam);
      var lyricMap = jsonDecode(lyricResponse.toString());
      rank.lyric = lyricMap;
    }
    state.playId = id;
    state.source = AudioSource.kugou;
    state.lyrics = LyricUtil.formatLyric(rank.lyric["lyric"]);
    state.lyricWidget = LyricView(state.lyrics, 0);
    state.name = rank.songName;
    state.picUrl = rank.albumSizableCover;
    state.artist = rank.singer;
    state.duration = const Duration();
    state.position = const Duration();

    play();
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

      next();

      update();
    });

    //监听报错
    audioPlayer.onPlayerError.listen((msg) {
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
    if (audioPlayer.state == PlayerState.PLAYING) {
      final result = await audioPlayer.pause();
      if (result == 1) {
        // print('pause succes');
      }
      return;
    }

    if (state.playId == null) return;
    String songId = state.playId!;
    var dio = Dio();
    Map<String, dynamic> header = AuthUtil.getHeader(Api.play);
    Map<String, dynamic> param = {
      "id": songId,
      "source": state.sourceStr,
      "type": "play"
    };
    dio.options.headers = header;
    final response = await dio.get(Api.play, queryParameters: param);
    SongDetail detail = SongDetail.fromJson(jsonDecode(response.toString()));
    String url = detail.url ?? "";
    if (url.isEmpty) return;
    final playPosition = (state.position.inMilliseconds > 0 &&
            state.position.inMilliseconds < state.duration.inMilliseconds)
        ? state.position
        : const Duration();

    if (url.isEmpty) {
      // print("url 为空");
      return;
    }

    final result = await audioPlayer.play(url, position: playPosition);
    if (result == 1) {
      print('play succes');
    }
  }

  previous() {
    print(playItems.length);
    print(playIndex);
    if (playItems.isNotEmpty && playIndex < playItems.length - 1) {
      int next = playIndex - 1;

      var first = playItems.first;
      if (first is HistoryPo) {
        initState(playItems.cast<HistoryPo>(), next);
      }

      if (first is SongListItem) {
        initSongListItem(state.source, playItems.cast<SongListItem>(), next);
      }

      if (first is SongRankModel) {
        initRankSong(state.source, playItems.cast<SongRankModel>(), next);
      }
    }
  }

  next() {
    if (playItems.isNotEmpty && playIndex < playItems.length - 1) {
      int next = playIndex + 1;

      var first = playItems.first;
      if (first is HistoryPo) {
        initState(playItems.cast<HistoryPo>(), next);
      }

      if (first is SongListItem) {
        initSongListItem(state.source, playItems.cast<SongListItem>(), next);
      }

      if (first is SongRankModel) {
        initRankSong(state.source, playItems.cast<SongRankModel>(), next);
      }
    }
  }
}
