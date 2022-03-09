import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weapon/auto_ui.dart';
import 'package:weapon/home/home_controller.dart';
import 'package:weapon/home/search_widget.dart';
import 'package:weapon/model/history_po.dart';
import 'package:weapon/model/play_list_item_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController controller = Get.put(HomeController());
  BoxDecoration selectedDec = const BoxDecoration();

  @override
  void initState() {
    super.initState();

    selectedDec = BoxDecoration(
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
        ]
        // border: Border.all(width: 1,color: Colors.redAccent.withAlpha(100))
        );
  }

  @override
  Widget build(BuildContext context) {

    return GetBuilder<HomeController>(
      builder: (controller) {
        return Container(
          color: const Color(0xffF6F8F9),
          child: Column(
            children: [
              _searchWidget(),
              Expanded(
                child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 20.dp,
                        ),
                        sectionHeader("assets/images/stars.png", "热门歌单"),
                        SizedBox(
                          height: 15.dp,
                        ),
                        _playListWidget(),
                        SizedBox(
                          height: 20.dp,
                        ),
                        sectionHeader("assets/images/rank.png", "排行榜"),
                        ListView.separated(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          itemBuilder: (ctx, index) {
                            return _itemWidget(index);
                          },
                          shrinkWrap: true,
                          itemCount: controller.state.histories.length,
                          separatorBuilder: (ctx, index) {
                            return const SizedBox(
                              height: 5,
                            );
                          },
                        )
                      ],
                    )
                )
              ),
            ],
          ),
        );
      },
    );
  }

  /// 搜索
  _searchWidget() {
    return Padding(
      padding: EdgeInsets.only(left: 15.dp, right: 15.dp, top: 15.dp),
      child: SearchWidget(
        start: controller.startSearch,
      ),
    );
  }

  /// 专辑
  _playListWidget() {
    return Container(
      height: 130.dp,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15.dp),
        itemBuilder: (ctx, index) {
          return _playListItemWidget(index);
        },
        shrinkWrap: true,
        itemCount: controller.state.playList.length,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (ctx, index) {
          return SizedBox(
            width: 15.dp,
          );
        },
      ),
    );
  }

  _playListItemWidget(int index) {
    PlayListItemModel playListItem = controller.state.playList[index];
    return Container(
        width: 180.dp,
        child: Column(
          children: [
            Expanded(
              child: CachedNetworkImage(
                width: 180.dp,
                height: 120.dp,
                //maxHeightDiskCache: 10,
                imageUrl: playListItem.coverImgUrl ?? "",
                // placeholder: (context, url) => const CircleAvatar(
                //   backgroundColor: Colors.amber,
                //   radius: 150,
                // ),
                imageBuilder: (context, image) {
                  return Container(
                    width: 180.dp,
                    height: 140.dp,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.dp),
                        image: DecorationImage(image: image, fit: BoxFit.cover),
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0xffd2d2d2).withAlpha(166),
                              offset: const Offset(4, 4),
                              blurRadius: 5.0,
                              spreadRadius: 0)
                        ]),
                  );
                },
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fadeOutDuration: const Duration(seconds: 1),
                fadeInDuration: const Duration(seconds: 3),
              ),
            ),
            SizedBox(
              height: 8.dp,
            ),
            Text(
              playListItem.name ?? "",
              maxLines: 1,
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF999999),
              ),
              overflow: TextOverflow.ellipsis,
            )
          ],
        ));
  }

  Widget sectionHeader(String icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            width: 20.sp,
            fit: BoxFit.contain,
          ),
          SizedBox(
            width: 15.dp,
          ),
          Text(
            title,
            maxLines: 1,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF999999),
            ),
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }

  /// 排行榜
  _rankWidget() {}

  _itemWidget(int index) {
    HistoryPo item = controller.state.histories[index];
    String url = item.picUrl;
    int munite = (item.dt / 60).ceil();
    String muniteStr = "$munite";
    if (munite < 10) muniteStr = "0$munite";
    int seconds = (item.dt % 60).ceil();
    String secondStr = "$seconds";
    if (seconds < 10) secondStr = "0$seconds";
    String time = "$muniteStr:$secondStr";
    String artistName = item.artist.map((e) => e.name).toList().join(",");

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
      height: 70.dp,
      decoration: controller.state.selectedIndex == index
          ? selectedDec
          : const BoxDecoration(color: Color(0xffF6F8F9)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => controller.chooseSong(item, index),
            child: Container(
              padding: EdgeInsets.only(left: 15.dp),
              child: Icon(
                controller.state.selectedIndex == index
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
              flex: 1,
              child: Row(
                children: [
                  CachedNetworkImage(
                    width: 40.dp,
                    height: 40.dp,
                    //maxHeightDiskCache: 10,
                    imageUrl: url,
                    // placeholder: (context, url) => const CircleAvatar(
                    //   backgroundColor: Colors.amber,
                    //   radius: 150,
                    // ),
                    imageBuilder: (context, image) => CircleAvatar(
                      backgroundImage: image,
                      radius: 6,
                    ),
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fadeOutDuration: const Duration(seconds: 1),
                    fadeInDuration: const Duration(seconds: 3),
                  ),
                  SizedBox(
                    width: 20.dp,
                  ),
                  Expanded(
                    child: Text(
                      item.name,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF333333),
                          fontWeight: FontWeight.w500),
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
                      fontSize: 13.sp, color: const Color(0xFF666666)))),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.access_time,
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
                        fontSize: 13.sp, color: const Color(0xFF999999)))
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.only(left: 15.dp, right: 15.dp),
              child: const Icon(
                Icons.more_horiz_rounded,
                size: 16,
                color: Color(0xFF999999),
              ),
            ),
          )
        ],
      ),
    );
  }
}
