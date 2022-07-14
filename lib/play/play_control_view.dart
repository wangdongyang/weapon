import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:weapon/auto_ui.dart';
import 'package:weapon/base/base_scaffold.dart';
import 'package:weapon/custom/play_view_app_bar.dart';
import 'package:weapon/home/search_widget.dart';
import 'package:weapon/play/play_controller.dart';
import 'package:weapon/utils/navigator_util.dart';
import 'package:weapon/utils/time_format_util.dart';

class PlayControlView extends StatefulWidget {
  const PlayControlView({
    Key? key,
  }) : super(key: key);

  @override
  _PlayControlViewState createState() {
    return _PlayControlViewState();
  }
}

class _PlayControlViewState extends State<PlayControlView>
    with TickerProviderStateMixin {
  PlayController controller = Get.find<PlayController>();

  @override
  Widget build(BuildContext context) {

    return BaseScaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "正在播放",
            style: TextStyle(
              fontSize: 15.sp,
              color: const Color(0xFF2d2d2d),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Color(0xFF2d2d2d),
                  size: 20,
                ),
                onPressed: () {
                  NavigatorUtil.pop(context, returnData: {});
                },
              );
            },
          ),
        ),
        backgroundColor: const Color(0xffF6F8F9),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.dp),
          child: GetBuilder<PlayController>(
            builder: (controller) {
              String url = controller.state.currentPo.picUrl;
              String name = controller.state.currentPo.name;
              String artist = controller.state.currentPo.artistStr;
              double width = (MediaQuery.of(context).size.width - 15.dp * 2);
              String position = TimeFormatUtil.secondToTimeString(
                  controller.state.position.inSeconds);
              String duration = TimeFormatUtil.secondToTimeString(
                  controller.state.duration.inSeconds);
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                    imageUrl: url,
                    // fit: BoxFit.contain,
                    imageBuilder: (context, image) {
                      return Container(
                        height: width*1.2,
                        width: width,
                        // height: double.infinity,
                        // child: Image.,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.dp),
                            image: DecorationImage(
                                image: image, fit: BoxFit.cover),
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0xffd2d2d2).withAlpha(120),
                                  offset: const Offset(4, 4),
                                  blurRadius: 5.0,
                                  spreadRadius: 0)
                            ]),
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
                    height: 30.dp,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(name,
                          style: TextStyle(
                            color: const Color(0xFF333333),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w400,
                          )),
                      GestureDetector(
                        onTap: controller.collect,
                        child: Image.asset(
                          controller.state.isSaved
                              ? "assets/images/collected.png"
                              : "assets/images/no_collected.png",
                          width: 20.dp,
                          height: 20.dp,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12.dp,
                  ),
                  Text(artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: const Color(0xFF666666),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                      )),
                  SizedBox(
                    height: 35.dp,
                  ),
                  _progressWidget(),
                  SizedBox(
                    height: 6.dp,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(position,
                            style: TextStyle(
                              color: const Color(0xFF666666),
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                            )),
                        Text(duration,
                            style: TextStyle(
                              color: const Color(0xFF666666),
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                            ))
                      ]),
                  SizedBox(
                    height: 35.dp,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: controller.previous,
                        child: Image.asset(
                          "assets/images/random.png",
                          width: 26.dp,
                          height: 26.dp,
                          fit: BoxFit.contain,
                        ),
                      ),
                      GestureDetector(
                        onTap: controller.previous,
                        child: Image.asset(
                          "assets/images/last.png",
                          width: 24.dp,
                          height: 24.dp,
                          fit: BoxFit.contain,
                        ),
                      ),
                      GestureDetector(
                        onTap: controller.stopAndPlay,
                        child: Image.asset(
                          controller.isPlaying
                              ? "assets/images/play.png"
                              : "assets/images/stop.png",
                          width: 54.dp,
                          fit: BoxFit.contain,
                        ),
                      ),
                      GestureDetector(
                        onTap: controller.next,
                        child: Image.asset(
                          "assets/images/next.png",
                          width: 24.dp,
                          height: 24.dp,
                          fit: BoxFit.contain,
                        ),
                      ),
                      GestureDetector(
                        onTap: controller.previous,
                        child: Image.asset(
                          "assets/images/repeat.png",
                          width: 26.dp,
                          height: 26.dp,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  )
                ],
              );
            },
          ),
        ));
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
