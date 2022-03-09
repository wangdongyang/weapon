import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weapon/auto_ui.dart';
import 'package:weapon/home/search_widget.dart';
import 'package:weapon/model/history_po.dart';
import 'package:weapon/model/song_list_item.dart';
import 'package:weapon/search/search_bar.dart';
import 'package:weapon/search/search_controller.dart';

class SearchView extends StatelessWidget {
  SearchView({Key? key}) : super(key: key);

  final SearchController controller = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffF6F8F9),
      child: GetBuilder<SearchController>(builder: (logic) {
        return Column(
          children: [
            _searchWidget(),
            Expanded(
              child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    itemBuilder: (ctx, index) {
                      return _itemWidget(index);
                    },
                    shrinkWrap: true,
                    primary: false,
                    itemCount: controller.state.songs.length,
                    separatorBuilder: (ctx, index) {
                      return const SizedBox(
                        height: 5,
                      );
                    },
                  )),
            )
          ],
        );
      }),
    );
  }

  /// 搜索
  _searchWidget() {
    return Padding(
      padding: EdgeInsets.only(left: 15.dp, right: 15.dp, top: 15.dp),
      child: SearchBar(
        searchBarController: controller.state.searchBarController,
        searchFocus: controller.state.searchFocus,
        menuItems: controller.state.subRouteNameMenuItems,
        sources: controller.state.sources,
        selectedName: controller.state.selectedName,
        menuChanged: (text) => controller.menuChanged(text),
        search: () => controller.search(),
      ),
    );
  }

  _itemWidget(int index) {
    SongListItem item = controller.state.songs[index];
    // String url = item.picUrl;
    // int munite = (item.dt / 60).ceil();
    // String muniteStr = "$munite";
    // if (munite < 10) muniteStr = "0$munite";
    // int seconds = (item.dt % 60).ceil();
    // String secondStr = "$seconds";
    // if (seconds < 10) secondStr = "0$seconds";
    // String time = "$muniteStr:$secondStr";
    // String artistName = item.artist.map((e) => e.name).toList().join(",");

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
      height: 70.dp,
      // decoration: controller.state.selectedIndex == index
      //     ? selectedDec
      //     : const BoxDecoration(color: Color(0xffF6F8F9)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: null, //controller.chooseSong(item, index),
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
                  // CachedNetworkImage(
                  //   width: 40.dp,
                  //   height: 40.dp,
                  //   //maxHeightDiskCache: 10,
                  //   imageUrl: url,
                  //   // placeholder: (context, url) => const CircleAvatar(
                  //   //   backgroundColor: Colors.amber,
                  //   //   radius: 150,
                  //   // ),
                  //   imageBuilder: (context, image) => CircleAvatar(
                  //     backgroundImage: image,
                  //     radius: 6,
                  //   ),
                  //   placeholder: (context, url) =>
                  //       const CircularProgressIndicator(),
                  //   errorWidget: (context, url, error) =>
                  //       const Icon(Icons.error),
                  //   fadeOutDuration: const Duration(seconds: 1),
                  //   fadeInDuration: const Duration(seconds: 3),
                  // ),
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
          // Expanded(
          //     flex: 1,
          //     child: Text(artistName,
          //         maxLines: 1,
          //         textAlign: TextAlign.center,
          //         overflow: TextOverflow.ellipsis,
          //         style: TextStyle(
          //             fontSize: 13.sp, color: const Color(0xFF666666)))),
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
                // Text(time,
                //     maxLines: 1,
                //     textAlign: TextAlign.end,
                //     overflow: TextOverflow.ellipsis,
                //     style: TextStyle(
                //         fontSize: 13.sp, color: const Color(0xFF999999)))
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
