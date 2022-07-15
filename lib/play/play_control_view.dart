import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:weapon/auto_ui.dart';
import 'package:weapon/base/base_scaffold.dart';
import 'package:weapon/custom/background_shower.dart';
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
    with TickerProviderStateMixin, SingleTickerProviderStateMixin {
  PlayController controller = Get.find<PlayController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller.state.animationController = AnimationController(
        duration: const Duration(seconds: 1200), vsync: this);
    controller.state.animation = Tween<double>(
      begin: 1,
      end: 80,
    ).animate(controller.state.animationController!)
      ..addStatusListener((status) {
        // if (status == AnimationStatus.completed) {
        //   // 动画完成后反转
        //   controller.state.animationController.reverse();
        // } else if (status == AnimationStatus.dismissed) {
        //   // 反转回初始状态时继续播放，实现无限循环
        //   controller.state.animationController.forward();
        // }
      });
    if (controller.isPlaying) {
      controller.state.animationController?.forward();
    }
  }

  @override
  void dispose() {
    controller.state.animationController?.dispose();
    super.dispose();
  }

  _headerWidget() {
    String name = controller.state.currentPo.name;
    String artist = controller.state.currentPo.artistStr;
    return AppBar(
        centerTitle: true,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              name,
              style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xffdbd9d9),
                  fontWeight: FontWeight.w400),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 5.dp,
            ),
            Text(
              artist,
              style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xffbfbfbf),
                  fontWeight: FontWeight.w300),
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Color(0xffffffff),
              size: 24,
            ),
            onPressed: () {
              NavigatorUtil.pop(context, returnData: {});
            },
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    SystemUiOverlayStyle style = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xffFFFFFF),
      systemNavigationBarDividerColor: Color(0xffFFFFFF),
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: style,
      child: BaseScaffold(
          // backgroundColor: const Color(0xffd41313), //const Color(0xffF6F8F9),
          body: GetBuilder<PlayController>(
        builder: (controller) {
          // String name = controller.state.currentPo.name;
          // String artist = controller.state.currentPo.artistStr;
          String position = TimeFormatUtil.secondToTimeString(
              controller.state.position.inSeconds);
          String duration = TimeFormatUtil.secondToTimeString(
              controller.state.duration.inSeconds);
          String url = controller.state.currentPo.picUrl;
          double width = (MediaQuery.of(context).size.width);
          double height = (MediaQuery.of(context).size.height);
          return Stack(
            children: [
              CachedNetworkImage(
                imageUrl: url,
                imageBuilder: (context, image) {
                  return Container(
                    height: height,
                    width: width,
                    // height: double.infinity,
                    // child: Image.,
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(width * 0.6),
                      image: DecorationImage(image: image, fit: BoxFit.fill),
                      // boxShadow: [
                      //   BoxShadow(
                      //       color: const Color(0xffd2d2d2).withAlpha(120),
                      //       offset: const Offset(4, 4),
                      //       blurRadius: 5.0,
                      //       spreadRadius: 0)
                      // ],
                      // border: Border.all(width: 2.dp, color: Colors.white)
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
              BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 22.0, sigmaY: 22.0),
                  child: Opacity(
                    opacity: 0.6,
                    child: Container(
                      height: height,
                      width: width,
                      color: Colors.black,
                    ),
                  )),
              Column(
                children: [
                  _headerWidget(),
                  SizedBox(
                    height: 60.dp,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _albumPictureWidget(),
                        SizedBox(
                          height: 50.dp,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15.dp),
                          child: Column(
                            children: [
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
                                height: 20.dp,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: controller.previous,
                                    child: Image.asset(
                                      "assets/images/last.png",
                                      width: 40.dp,
                                      height: 40.dp,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      controller.stopAndPlay();
                                    },
                                    child: Image.asset(
                                      controller.isPlaying
                                          ? "assets/images/pause.png"
                                          : "assets/images/play.png",
                                      width: 55.dp,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: controller.next,
                                    child: Image.asset(
                                      "assets/images/next.png",
                                      width: 40.dp,
                                      height: 40.dp,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: controller.collect,
                                    child: Image.asset(
                                      controller.state.isSaved
                                          ? "assets/images/loved.png"
                                          : "assets/images/love.png",
                                      width: 40.dp,
                                      height: 40.dp,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 60.dp,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          );
        },
      )),
    );
  }

  Widget _albumPictureWidget() {
    String url = controller.state.currentPo.picUrl;
    double width = (MediaQuery.of(context).size.width - 15.dp * 2);
    return RotationTransition(
      alignment: Alignment.center,
      turns: controller.state.animation!,
      child: Container(
        width: width * 0.8,
        height: width * 0.8,
        alignment: Alignment.center,
        child: Stack(
          children: [
            Positioned(
              left: width * 0.05,
              top: width * 0.05,
              child: CachedNetworkImage(
                imageUrl: url,
                imageBuilder: (context, image) {
                  return Container(
                    width: width * 0.7,
                    height: width * 0.7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(width * 0.7),
                      image:
                          DecorationImage(image: image, fit: BoxFit.fitWidth),
                      // boxShadow: [
                      //   BoxShadow(
                      //       color: const Color(0xffd2d2d2).withAlpha(120),
                      //       offset: const Offset(4, 4),
                      //       blurRadius: 5.0,
                      //       spreadRadius: 0)
                      // ],
                      // border: Border.all(width: 10.dp, color: Colors.black)
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
            ),
            Image.asset(
              "assets/images/play_disc.png",
              width: width * 0.8,
              height: width * 0.8,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
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
        trackHeight: 1,
        trackShape: const RectangularSliderTrackShape(),
      ),
      child: Slider(
        // divisions: 5,
        inactiveColor: Colors.white,
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
