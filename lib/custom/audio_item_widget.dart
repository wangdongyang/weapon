import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:weapon/auto_ui.dart';
import 'package:weapon/model/song_list_item.dart';
import 'package:weapon/utils/time_format_util.dart';

class AudioItemWidget extends StatelessWidget {
  String name = "";
  String picUrl = "";
  int duration = 0;
  List<ArtistModel>? artist = [];
  List<String>? artistStrArr = [];
  String? singer = "";
  bool isChoose = false;
  Function clickCallBack;
  Function moreCallBack;

  AudioItemWidget(
      {Key? key,
      required this.name,
      required this.picUrl,
      required this.duration,
      this.artist,
      this.artistStrArr,
      this.singer,
      required this.isChoose,
      required this.clickCallBack,
      required this.moreCallBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _itemWidget();
  }

  _itemWidget() {
    String url = picUrl;
    String time = TimeFormatUtil.secondToTimeString(duration);

    String artistName = singer ?? "";
    // if (artist != null && artist!.isNotEmpty) {
    //   artistName = artist!.map((e) => e.name).toList().join(",");
    // }

    // if (artistStrArr != null && artistStrArr!.isNotEmpty) {
    //   artistName = artistStrArr!.map((e) => e).toList().join(",");
    // }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.dp, horizontal: 10.dp),
      height: 70.dp,
      decoration: isChoose
          ? BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(
                Radius.circular(14),
              ),
              boxShadow: [
                  BoxShadow(
                      color: const Color(0xFFF1F1F1).withAlpha(188),
                      offset: const Offset(0, 6),
                      blurRadius: 5.0,
                      spreadRadius: 0)
                ])
          : const BoxDecoration(color: Color(0xffF6F8F9)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 10.dp,
          ),
          GestureDetector(
            onTap: () {
              clickCallBack();
            },
            child: Container(
              // padding: EdgeInsets.only(left: 15.dp),
              child: Icon(
                isChoose
                    ? Icons.pause_circle_rounded
                    : Icons.play_arrow_rounded,
                size: 20.sp,
                color: Color(0xffc7c7c7),
              ),
            ),
          ),
          SizedBox(
            width: 20.dp,
          ),
          Expanded(
              flex: 2,
              child: Row(
                children: [
                  CachedNetworkImage(
                    width: 42.dp,
                    height: 42.dp,
                    imageUrl: url,
                    imageBuilder: (context, image) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(image: image),
                        borderRadius: BorderRadius.all(
                          Radius.circular(21.dp),
                        ),
                        border: Border.all(width: 1.5.dp, color: Colors.white),
                      ),
                    ),
                    placeholder: (context, url) => Image.asset(
                      "assets/images/album.png",
                      width: 42.dp,
                      height: 42.dp,
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
                      color: Color(0xFFcccccc),
                    ),
                    fadeOutDuration: const Duration(seconds: 1),
                    fadeInDuration: const Duration(seconds: 1),
                  ),
                  SizedBox(
                    width: 20.dp,
                  ),
                  Expanded(
                    child: Text(
                      name,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: const Color(0xFF333333),
                        fontWeight: FontWeight.w400
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              )),
          Expanded(
              flex: 1,
              child: Text(artistName,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 14.sp, color: const Color(0xFF666666)))),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 16.dp,
                  color: const Color(0xFF999999),
                ),
                SizedBox(
                  width: 5.dp,
                ),
                Text(time,
                    maxLines: 1,
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 13.sp, color: const Color(0xFF999999)))
              ],
            ),
          ),
          // GestureDetector(
          //   onTap: () {
          //     if (moreCallBack != null) {
          //       moreCallBack();
          //     }
          //   },
          //   child: Container(
          //     padding: EdgeInsets.only(left: 15.dp, right: 0.dp),
          //     child: const Icon(
          //       Icons.more_horiz_rounded,
          //       size: 16,
          //       color: Color(0xFF999999),
          //     ),
          //   ),
          // ),
          SizedBox(
            width: 10.dp,
          ),
        ],
      ),
    );
  }
}
