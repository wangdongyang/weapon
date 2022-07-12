import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weapon/auto_ui.dart';
import 'package:weapon/play/lyric_view.dart';
import 'package:weapon/play/play_controller.dart';
import 'package:weapon/utils/audio_player_util.dart';
import 'package:weapon/utils/lyric_util.dart';
import 'package:window_size/window_size.dart' as window_size;

class MobilePlayView extends StatefulWidget {
  MobilePlayView({
    Key? key,
  }) : super(key: key);

  @override
  _MobilePlayViewState createState() {
    return _MobilePlayViewState();
  }
}

class _MobilePlayViewState extends State<MobilePlayView>
    with TickerProviderStateMixin {
  final PlayController controller = Get.put(PlayController());
  double playViewWidth = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlayController>(
      builder: (controller) {
        String url = controller.state.currentPo.picUrl;
        String name = controller.state.currentPo.name;
        String artist = controller.state.currentPo.artistStr;
        double iconSize = 25.dp;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.dp),
          child: SizedBox(
            height: 80.dp,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 5.dp,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.dp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl: url,
                              imageBuilder: (context, image) {
                                return Container(
                                  // width: playViewWidth,
                                  height: 54.dp,
                                  width: 54.dp,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.dp),
                                      image: DecorationImage(
                                          image: image, fit: BoxFit.cover),
                                      // boxShadow: [
                                      //   BoxShadow(
                                      //       color: const Color(0xffd2d2d2)
                                      //           .withAlpha(166),
                                      //       offset: const Offset(4, 4),
                                      //       blurRadius: 5.0,
                                      //       spreadRadius: 0)
                                      // ]
                                  ),
                                );
                              },
                              placeholder: (context, url) => CircleAvatar(
                                backgroundColor: Colors.blue.shade300,
                                radius: 20.dp,
                              ),
                              errorWidget: (context, url, error) => Container(),
                              fadeOutDuration: const Duration(seconds: 1),
                              fadeInDuration: const Duration(seconds: 1),
                            ),
                            SizedBox(
                              width: 20.dp,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: const Color(0xFF333333),
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                    )),
                                SizedBox(
                                  height: 10.dp,
                                ),
                                Text(artist,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: const Color(0xFF333333),
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w400,
                                    )),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: controller.previous,
                              child: Container(
                                child: Icon(
                                  Icons.skip_previous_rounded,
                                  size: iconSize,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20.dp,
                            ),
                            GestureDetector(
                              onTap: controller.stopAndPlay,
                              child: Container(
                                child: controller.isPlaying
                                    ? Icon(
                                        Icons.pause_circle_outline_rounded,
                                        size: iconSize,
                                      )
                                    : Icon(
                                        Icons.play_arrow_rounded,
                                        size: iconSize,
                                      ),
                              ),
                            ),
                            SizedBox(
                              width: 20.dp,
                            ),
                            GestureDetector(
                              onTap: controller.next,
                              child: Container(
                                child: Icon(
                                  Icons.skip_next_rounded,
                                  size: iconSize,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                _progressWidget(),
              ],
            ),
          ),
        );
      },
    );
  }

  _progressWidget() {
    double value = 0.0;

    int position = controller.state.position.inMilliseconds;
    int duration = controller.state.duration.inMilliseconds;
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
          // AudioPlayerUtil.instance
          //     .seek(Duration(milliseconds: curPosition.round()));
        },
        value: value,
      ),
    );
  }
}
