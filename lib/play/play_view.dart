import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weapon/auto_ui.dart';
import 'package:weapon/play/lyric/lyric_view.dart';
import 'package:weapon/model/history_po.dart';
import 'package:weapon/model/lyric.dart';
import 'package:weapon/play/play_controller.dart';
import 'package:weapon/utils/audio_player_util.dart';
import 'package:weapon/utils/lyric_util.dart';

class PlayView extends StatefulWidget {
  String? picUrl;
  String? name;
  String? artist;
  LyricView? lyricWidget;
  PlayerState? playerState;
  List<Lyric> lyrics = [];
  Duration duration = const Duration();
  Duration position = const Duration();
  AnimationController? lyricOffsetYController;
  Timer? dragEndTimer;
  Function? previous;
  Function? play;
  Function? next;

  // Function? dragEndFunc;
  // Duration? dragEndDuration = const Duration(milliseconds: 1000);

  PlayView(
      {Key? key,
      this.name,
      this.picUrl,
      this.artist,
      this.lyricWidget,
      this.playerState,
      this.lyrics = const [],
      this.duration = const Duration(),
      this.position = const Duration(),
      this.lyricOffsetYController,
      this.dragEndTimer})
      : super(key: key);

  // final PlayController controller = Get.put(PlayController());

  // updatePlayer(HistoryPo data) {
  // historyPo = data;
  // controller.initState(data);
  // }

  @override
  _PlayViewState createState() {
    return _PlayViewState();
  }
}

class _PlayViewState extends State<PlayView> with TickerProviderStateMixin {
  // PlayController get controller => widget.controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((call) {
      // controller.initState(widget.historyPo);
    });
  }

  @override
  Widget build(BuildContext context) {
    String url = widget.picUrl ?? "";
    String name = widget.name ?? "";
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(color: Colors.white,
          // borderRadius: const BorderRadius.all(
          //   Radius.circular(40),
          // ),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFFF5F5F5).withAlpha(255),
                offset: const Offset(-4, 0.0),
                blurRadius: 5.0,
                spreadRadius: 0)
          ]
          // border: Border.all(width: 1,color: Colors.redAccent.withAlpha(100))
          ),
      child: Column(
        children: [
          SizedBox(
            height: 10.dp,
          ),
          _authorWidget(),
          SizedBox(
            height: 10.dp,
          ),
          Container(
            height: 0.2,
            color: Colors.black26,
          ),
          SizedBox(
            height: 20.dp,
          ),
          CachedNetworkImage(
            width: 200.dp,
            height: 200.dp,
            imageUrl: url,
            imageBuilder: (context, image) => CircleAvatar(
              backgroundImage: image,
              radius: 12.dp,
            ),
            placeholder: (context, url) => CircleAvatar(
              backgroundColor: Colors.blue.shade300,
              radius: 20.dp,
            ),
            errorWidget: (context, url, error) => Container(),
            fadeOutDuration: const Duration(seconds: 1),
            fadeInDuration: const Duration(seconds: 1),
          ),
          SizedBox(
            height: 20.dp,
          ),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: 10.dp,
          ),
          _progressWidget(),
          SizedBox(
            height: 10.dp,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  icon: const Icon(Icons.skip_previous_rounded),
                  onPressed: () => widget.previous),
              IconButton(
                  icon: widget.playerState == PlayerState.PLAYING
                      ? const Icon(Icons.pause_circle_outline_rounded)
                      : const Icon(Icons.play_arrow_rounded),
                  onPressed: () => widget.play),
              IconButton(
                  icon: const Icon(Icons.skip_next_rounded),
                  onPressed: () => widget.next),
            ],
          ),
          _lyricContainerWidget()
        ],
      ),
    );
  }

  _lyricContainerWidget() {
    if (widget.lyrics.isEmpty) {
      return Container(
        alignment: Alignment.center,
        child: Text(
          '歌词加载中...',
          style: TextStyle(fontSize: 16.sp, color: Colors.white),
        ),
      );
    }
    int position = widget.position.inMilliseconds;
    int duration = widget.duration.inMilliseconds;
    var p = position > duration ? duration : position;
    int curLine = LyricUtil.findLyricIndex(p.toDouble(), widget.lyrics);

    // print("_lyricContainerWidget curLine = $curLine");
    bool isDragging = widget.lyricWidget?.isDragging ?? true;
    if (widget.lyrics.isNotEmpty && widget.lyricWidget != null) {
      if (!isDragging) {
        startLineAnim(curLine);
      }
      widget.lyricWidget?.curLine = curLine;
    }

    Size size = widget.lyricWidget?.canvasSize ?? const Size(0, 0);

    return Expanded(
      child: Container(
          child: GestureDetector(
        onTapDown: isDragging
            ? (e) {
                int dragLineTime = widget.lyricWidget?.dragLineTime ?? 0;
                if (e.localPosition.dx > 0 &&
                    e.localPosition.dx < 100.dp &&
                    e.localPosition.dy > size.height / 2 - 100.dp &&
                    e.localPosition.dy < size.height / 2 + 100.dp) {
                  AudioPlayerUtil.instance
                      .seek(Duration(milliseconds: dragLineTime));
                }
              }
            : null,
        onVerticalDragUpdate: (e) {
          if (!isDragging) {
            setState(() {
              widget.lyricWidget?.isDragging = true;
            });
          }
          widget.lyricWidget?.offsetY += e.delta.dy;
        },
        onVerticalDragEnd: (e) {
          cancelDragTimer();
        },
        child: CustomPaint(
          // size: Size(50, 50),
          painter: widget.lyricWidget,
        ),
      )),
    );
  }

  void cancelDragTimer() {
    // if (controller.state.dragEndTimer != null) {
    //   if (controller.state.dragEndTimer.isActive) {
    //     controller.state.dragEndTimer.cancel();
    //     // controller.state.dragEndTimer.;
    //   }
    // }
    // dragEndTimer = Timer(dragEndDuration, dragEndFunc);
  }

  /// 开始下一行动画
  void startLineAnim(int curLine) {
    // 判断当前行和 customPaint 里的当前行是否一致，不一致才做动画
    if (widget.lyricWidget == null) return;
    LyricView lyricView = widget.lyricWidget!;
    if (lyricView.curLine != curLine) {
      var lyricOffsetYController = widget.lyricOffsetYController;
      // 如果动画控制器不是空，那么则证明上次的动画未完成，
      // 未完成的情况下直接 stop 当前动画，做下一次的动画
      if (lyricOffsetYController != null) {
        lyricOffsetYController.stop();
      }

      // 初始化动画控制器，切换歌词时间为300ms，并且添加状态监听，
      // 如果为 completed，则消除掉当前controller，并且置为空。
      lyricOffsetYController = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 300))
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            lyricOffsetYController?.dispose();
          }
        });
      // 计算出来当前行的偏移量
      var end = lyricView.computeScrollY(curLine) * -1;
      // 起始为当前偏移量，结束点为计算出来的偏移量

      Animation animation = Tween<double>(begin: lyricView.offsetY, end: end)
          .animate(lyricOffsetYController);
      // 添加监听，在动画做效果的时候给 offsetY 赋值
      lyricOffsetYController.addListener(() {
        lyricView.offsetY = animation.value;
      });
      // 启动动画
      lyricOffsetYController.forward();
    }
  }

  _progressWidget() {
    double value = 0.0;

    int position = widget.position.inMilliseconds;
    int duration = widget.duration.inMilliseconds;
    if (position > 0 && position < duration) {
      value = position / duration;
    }
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        //slider modifications
        thumbColor: const Color(0xFFEB1555),
        inactiveTrackColor: const Color(0xFF8D8E98),
        activeTrackColor: Colors.white,
        overlayColor: const Color(0x99EB1555),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5.0),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 1.0),
        trackHeight: 2,
        trackShape: const RectangularSliderTrackShape(),
      ),
      child: Slider(
        // divisions: 5,
        inactiveColor: Colors.black87,
        activeColor: Colors.redAccent,
        onChanged: (v) {
          final curPosition = v * duration;
          AudioPlayerUtil.instance
              .seek(Duration(milliseconds: curPosition.round()));
        },
        value: value,
      ),
    );
  }

  _authorWidget() {
    String url = widget.picUrl ?? "";
    // String name =
    //     widget.historyPo?.artist.map((e) => e.name).toList().join(",") ?? "";
    String name = widget.artist ?? "";
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          CachedNetworkImage(
            width: 40.dp,
            height: 40.dp,
            imageUrl: url,
            imageBuilder: (context, image) => CircleAvatar(
              backgroundImage: image,
              radius: 20.dp,
            ),
            placeholder: (context, url) => CircleAvatar(
              backgroundColor: Colors.blue.shade300,
              radius: 20.dp,
            ),
            errorWidget: (context, url, error) => CircleAvatar(
              backgroundColor: Colors.blue.shade300,
              radius: 20.dp,
            ),
            fadeOutDuration: const Duration(seconds: 1),
            fadeInDuration: const Duration(seconds: 1),
          ),
          SizedBox(
            width: 10.dp,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  style: TextStyle(fontSize: 14.sp, color: Color(0xFF333333)),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 5.dp,
                ),
                Text(
                  "这是谁啊？",
                  maxLines: 1,
                  style: TextStyle(fontSize: 11.sp, color: Color(0xFF666666)),
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
