import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:weapon/auto_ui.dart';
import 'package:weapon/db/local_db.dart';
import 'package:weapon/model/history_po.dart';
import 'package:weapon/model/song_detail.dart';
import 'package:weapon/model/song_list_item.dart';
import 'package:weapon/utils/auth_util.dart';
import 'package:weapon/utils/crypt_util.dart';
import 'package:weapon/utils/leancloud_util.dart';
import 'package:window_size/window_size.dart';

enum AudioSource { netease, tencent, xiami, kugou, baidu, kuwo }

class AudioPlayPage extends StatefulWidget {
  const AudioPlayPage({Key? key}) : super(key: key);

  @override
  _AudioPlayPageState createState() => _AudioPlayPageState();
}

class _AudioPlayPageState extends State<AudioPlayPage> {
  late String url;
  late PlayerMode mode;

  late AudioPlayer _audioPlayer;

  late Duration _duration = Duration();
  late Duration _position = Duration();
  late StreamSubscription _durationSubscription;
  late StreamSubscription _positionSubscription;
  late StreamSubscription _playerCompleteSubscription;
  late StreamSubscription _playerErrorSubscription;
  late StreamSubscription _playerStateSubscription;

  get _durationText => _duration.toString().split('.').first;

  get _positionText => _position.toString().split('.').first;

  final TextEditingController _searchBarController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  bool _isSearching = false;
  List<SongListItem> songs = [];
  final List<Map<String, dynamic>> _subroute = [
    {"name": "网易", "source": AudioSource.netease},
    {"name": "腾讯", "source": AudioSource.tencent},
    {"name": "小米", "source": AudioSource.xiami},
    {"name": "酷狗", "source": AudioSource.kugou},
    {"name": "百度", "source": AudioSource.baidu},
    {"name": "酷我", "source": AudioSource.kuwo},
  ];
  List<DropdownMenuItem<String>> _subrouteNameMenuItems = [];
  String _selectedRouteName = "";
  AudioSource _audioSource = AudioSource.netease;

  // SongDetail _songDetail;
  String picUrl = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initAudioPlayer();
    // 初始化线路名及部分线路的子线列表选择器
    _updateSubrouteMenuItems();
    _selectedRouteName = _subroute.first["name"];
  }

  void _updateSubrouteMenuItems() {
    _subrouteNameMenuItems =
        _subroute.map<DropdownMenuItem<String>>((Map<String, dynamic> route) {
      return DropdownMenuItem(
        value: route["name"],
        onTap: () {
          _audioSource = route["source"];
        },
        child: Text(
          route["name"],
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    //释放
    _audioPlayer.dispose();
    _durationSubscription.cancel();
    _positionSubscription.cancel();
    _playerCompleteSubscription.cancel();
    _playerErrorSubscription.cancel();
    _playerStateSubscription.cancel();
    super.dispose();
  }

  _initAudioPlayer() {
    //  /// Ideal for long media files or streams.
    mode = PlayerMode.MEDIA_PLAYER;
    //初始化
    _audioPlayer = AudioPlayer(mode: mode);

    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
      // TODO implemented for iOS, waiting for android impl
      // if (Theme.of(context).platform == TargetPlatform.iOS) {
      //   // (Optional) listen for notification updates in the background
      //   _audioPlayer.startHeadlessService();
      //
      //   // set at least title to see the notification bar on iOS.
      //   _audioPlayer.setNotification(
      //       title: 'App Name',
      //       artist: 'Artist or blank',
      //       albumTitle: 'Name or blank',
      //       imageUrl: 'url or blank',
      //       forwardSkipInterval: const Duration(seconds: 30), // default is 30s
      //       backwardSkipInterval: const Duration(seconds: 30), // default is 30s
      //       duration: duration,
      //       elapsedTime: Duration(seconds: 0));
      // }
    });

    //监听进度
    _positionSubscription = _audioPlayer.onAudioPositionChanged.listen((p) {
      setState(() {
        _position = p;
      });
    });

    //播放完成
    _playerCompleteSubscription =
        _audioPlayer.onPlayerCompletion.listen((event) {
//          _onComplete();
      setState(() {
        _position = Duration();
      });
    });

    //监听报错
    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
//        _playerState = PlayerState.stopped;
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
      });
    });

    //播放状态改变
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {});
    });

    ///// iOS中来自通知区域的玩家状态变化流。
    _audioPlayer.onNotificationPlayerStateChanged.listen((state) {
      if (!mounted) return;
    });

//    _playingRouteState = PlayingRouteState.speakers;
  }

  //开始播放
  void _play(String url) async {
    this.url = url;
    final playPosition = (_position.inMilliseconds > 0 &&
            _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : null;
    final result = await _audioPlayer.play(url, position: playPosition);
    if (result == 1) {
      print('succes');
    }

    // default playback rate is 1.0
    // this should be called after _audioPlayer.play() or _audioPlayer.resume()
    // this can also be called everytime the user wants to change playback rate in the UI
    _audioPlayer.setPlaybackRate(1.0);
  }

  //暂停
  void _pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) {
      print('succes');
    }
  }

  //停止播放
  _stop() async {
    final result = await _audioPlayer.stop();
    if (result == 1) {
      setState(() {
        _position = Duration();
      });
    }
  }

  search() async {
    String text = _searchBarController.value.text;
    if (text.isEmpty) return;
    var dio = Dio();
    String host =
        "https://service-1neqmc80-1257701204.gz.apigw.tencentcs.com/release/music";
    Map<String, dynamic> header = AuthUtil.getHeader(host);
    dio.options.headers = header;
    Map<String, dynamic> param = {"keyword": text, "site": getAudioSource()};
    final response = await dio.get(host, queryParameters: param);
    print("param:$param; response: $response");
    List<dynamic> mapList = jsonDecode(response.toString());
    List<SongListItem> songs = [];
    for (var element in mapList) {
      songs.add(SongListItem.fromJson(element));
    }
    this.songs = songs;
    setState(() {});
  }

  getAudioSource() {
    return _audioSource.toString().split(".").last;
  }

  chooseSong(SongListItem item) async {
    String songId = item.id;
    var dio = Dio();
    String host =
        "https://service-1neqmc80-1257701204.gz.apigw.tencentcs.com/release/music";
    Map<String, dynamic> header = AuthUtil.getHeader(host);
    Map<String, dynamic> param = {"item_id": songId, "site": getAudioSource()};
    dio.options.headers = header;
    final response = await dio.get(host, queryParameters: param);
    print("param:$param; response: $response");
    SongDetail detail = SongDetail.fromJson(jsonDecode(response.toString()));

    Map<String, dynamic> picParam = {
      "pic": item.picId,
      "site": getAudioSource()
    };
    final picResponse = await dio.get(host, queryParameters: picParam);
    var picMap = jsonDecode(picResponse.toString());
    print("param:$picParam; response: $picResponse");
    picUrl = picMap["url"];

    Map<String, dynamic> lyricParam = {
      "lyric": item.lyricId,
      "site": getAudioSource()
    };
    final lyricResponse = await dio.get(host, queryParameters: lyricParam);
    var lyricMap = jsonDecode(lyricResponse.toString());
    print("param:$lyricParam; response: $lyricResponse");
    // picUrl = picMap["url"];

    // _songDetail = detail;
    await _stop();
    _play(detail.url ?? "");


    HistoryPo po = HistoryPo();
    po.name = item.name;
    po.artist = item.artist;
    po.playId = item.id;
    po.playUrl = detail.url ?? "";
    po.picId = item.picId;
    po.picUrl = picMap["url"];
    po.lyricId = item.lyricId;
    po.lyricUrl = lyricMap["lyric"];
    po.source = item.source;
    po.size = detail.size ?? 0;
    po.dt = item.dt;
    po.saveData();
  }

  @override
  Widget build(BuildContext context) {
    BoxDecoration decoration = const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ));

    Widget cancelWidget = Container();
    if (_isSearching) {
      cancelWidget = GestureDetector(
        onTap: () {
          _isSearching = false;
          songs = [];
          _searchBarController.clear();
          setState(() {});
        },
        child: Container(
            alignment: Alignment.center,
            height: 32,
            width: 50,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            child: const Text(
              "取消",
              style: TextStyle(color: Color(0xff666666), fontSize: 13),
            )),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Column(
        children: <Widget>[
          Container(
            decoration: decoration,
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Container(
              // height: SGScreenUtil.w(40),
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              // height: SGScreenUtil.h(40),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  _routeName(),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    // color: Colors.blue,
                    child: const Icon(
                      Icons.search,
                      size: 20,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    // height: SGScreenUtil.h(40),
                    child: TextField(
                      focusNode: _searchFocus,
                      controller: _searchBarController,
                      onChanged: (value) {
                        _isSearching = true;
                        setState(() {});
                      },
                      keyboardType: TextInputType.text,
                      style: const TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 14,
                          textBaseline: TextBaseline.alphabetic),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(
                            0, 0, 0, 6), //const EdgeInsets.all(0),
                        border: InputBorder.none,
                        hintText: "请输入...",
                        hintStyle:
                            TextStyle(color: Color(0xFF999999), fontSize: 13),
                      ),
                    ),
                  ),
                  cancelWidget,
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: search,
                    child: Container(
                      width: 80,
                      height: 50,
                      alignment: Alignment.center,
                      color: Colors.white,
                      child: const Text("搜索"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
                itemBuilder: (ctx, index) {
                  SongListItem item = songs[index];
                  return GestureDetector(
                    onTap: () => chooseSong(item),
                    child: Container(
                      height: 50,
                      // width: 300,
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Text(
                            item.artist.join(","),
                            maxLines: 1,
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                          ))
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (ctx, index) {
                  return const Divider(
                    height: 0.3,
                    color: Colors.grey,
                  );
                },
                itemCount: songs.length),
          ),
          Text(
            _position != null
                ? '${_positionText ?? ''} / ${_durationText ?? ''}'
                : _duration != null
                    ? _durationText
                    : '',
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                picUrl.isNotEmpty
                    ? Container(
                        child: Image(
                          width: 100.dp,
                          height: 100.dp,
                          image: NetworkImage(picUrl),
                          fit: BoxFit.contain,
                        ),
                      )
                    : Container(),
                Expanded(
                  child: Slider(
                    onChanged: (v) {
                      final Position = v * _duration.inMilliseconds;
                      _audioPlayer.seek(Duration(milliseconds: Position.round()));
                    },
                    value: (_position.inMilliseconds > 0 &&
                            _position.inMilliseconds < _duration.inMilliseconds)
                        ? _position.inMilliseconds / _duration.inMilliseconds
                        : 0.0,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.play_arrow),
                  onPressed: () {
                    _play(url);
                  }),
              IconButton(
                  icon: Icon(Icons.pause),
                  onPressed: () {
                    _pause();
                  }),
              IconButton(
                  icon: Icon(Icons.stop),
                  onPressed: () {
                    _stop();
                  }),
            ],
          )
        ],
      ),
    );
  }

  Widget _routeName() {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        items: _subrouteNameMenuItems,
        value: _selectedRouteName,
        selectedItemBuilder: (BuildContext context) {
          return _subroute.map<Widget>((Map<String, dynamic> route) {
            return Container(
              alignment: Alignment.center,
              child: Text(
                route["name"],
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            );
          }).toList();
        },
        iconEnabledColor: Colors.black38,
        focusColor: Colors.redAccent.shade100,
        dropdownColor: Colors.white,
        onChanged: (newValue) {
          setState(() {
            _selectedRouteName = newValue.toString();
          });
        },
      ),
    );
  }
}
