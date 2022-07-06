import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:weapon/auto_ui.dart';
import 'package:weapon/custom/back_button.dart';

import 'package:weapon/home/playlist/play_list_controller.dart';
import 'package:weapon/home/playlist/play_list_state.dart';
import 'package:weapon/home/songs_view.dart';
import 'package:weapon/model/play_list_item_model.dart';
import 'package:weapon/utils/color_util.dart';
import 'package:weapon/utils/navigator_util.dart';

class PlayListView extends StatefulWidget {
  const PlayListView({Key? key}) : super(key: key);

  @override
  _PlayListViewState createState() => _PlayListViewState();
}

class _PlayListViewState extends State<PlayListView> {
  final PlayListController controller = Get.put(PlayListController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.loadRefresh();
    controller.addScrollListener();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.state = PlayListState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffF6F8F9),
      child: Stack(
        children: [
          GetBuilder<PlayListController>(builder: (controller) {
            return ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: GridView.builder(
                padding: EdgeInsets.all(20.dp),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                controller: controller.state.scrollController,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    mainAxisSpacing: 20.dp,
                    crossAxisSpacing: 20.dp,
                    childAspectRatio: 1.4),
                itemBuilder: (BuildContext context, int index) {
                  return itemWidget(index);
                },
                itemCount: controller.state.playList.length,
              ),
            );
            // return EasyRefresh(
            //     controller: EasyRefreshController(),
            //     scrollController: ScrollController(),
            //     header: ClassicalHeader(refreshedText: "开始刷新"),
            //     footer:
            //         BallPulseFooter(color: Colors.red, enableInfiniteLoad: false),
            //     onLoad: () => controller.loadMore(),
            //     onRefresh: () => controller.loadRefresh(),
            //     child: ScrollConfiguration(
            //       behavior:
            //           ScrollConfiguration.of(context).copyWith(scrollbars: false),
            //       child: GridView.builder(
            //         padding: EdgeInsets.all(20.dp),
            //         scrollDirection: Axis.vertical,
            //         shrinkWrap: true,
            //         gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            //             maxCrossAxisExtent: 300,
            //             mainAxisSpacing: 20.dp,
            //             crossAxisSpacing: 20.dp,
            //             childAspectRatio: 1.4),
            //         itemBuilder: (BuildContext context, int index) {
            //           return itemWidget(index);
            //         },
            //         itemCount: controller.state.playList.length,
            //       ),
            //     ));
          }),
          Positioned(
              bottom: 30,
              right: 30,
              child: BackButtonWidget(
                clickCallBack: () {
                  NavigatorUtil.pop(context, returnData: {});
                },
              )),
        ],
      ),
    );
  }

  Widget itemWidget(int index) {
    PlayListItemModel item = controller.state.playList[index];
    return GestureDetector(
      onTap: () {
        NavigatorUtil.push(
            context,
            SongsView(
              playListItem: item,
              sourceType: SongSourceType.playList,
            ));
      },
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.dp),
              boxShadow: [
                BoxShadow(
                    color: const Color(0xffe0e0e0).withAlpha(100),
                    offset: const Offset(6, 6),
                    blurRadius: 7.0,
                    spreadRadius: 0),
                BoxShadow(
                    color: const Color(0xffe0e0e0).withAlpha(100),
                    offset: const Offset(-6, -6),
                    blurRadius: 7.0,
                    spreadRadius: 0),
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: item.coverImgUrl ?? "",
                  imageBuilder: (context, image) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.dp),
                            topRight: Radius.circular(8.dp)),
                        image: DecorationImage(image: image, fit: BoxFit.cover),
                      ),
                    );
                  },
                  placeholder: (context, url) => Container(
                    decoration: BoxDecoration(
                      color: ColorUtil.randomColor().withAlpha(40),
                      borderRadius: BorderRadius.circular(8.dp),
                    ),
                  ),
                  //card_place_image.png
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fadeOutDuration: const Duration(seconds: 1),
                  fadeInDuration: const Duration(seconds: 2),
                ),
              ),
              SizedBox(
                height: 10.dp,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0.dp),
                child: Text(
                  item.name ?? "",
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF404040),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: 15.dp,
              ),
            ],
          )),
    );
  }
}
