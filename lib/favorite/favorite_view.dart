import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:weapon/auto_ui.dart';
import 'package:weapon/base/base_scaffold.dart';
import 'package:weapon/custom/audio_item_widget.dart';
import 'package:weapon/custom/back_button.dart';
import 'package:weapon/favorite/favorite_controller.dart';
import 'package:weapon/model/history_po.dart';
import 'package:weapon/model/song_list_item.dart';

class FavoriteView extends StatelessWidget {
  FavoriteView({Key? key}) : super(key: key);
  final FavoriteController controller = Get.put(FavoriteController());

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid || Platform.isIOS) {

      return BaseScaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "我的收藏",
              style: TextStyle(
                fontSize: 15.sp,
                color: const Color(0xFF2d2d2d),
              ),
              overflow: TextOverflow.ellipsis,
            ),
            backgroundColor: Colors.white,
            elevation: 0.0,
          ),
          backgroundColor: const Color(0xffF6F8F9),
          body: EasyRefresh(
              controller: EasyRefreshController(),
              scrollController: ScrollController(),
              header: BallPulseHeader(color: const Color(0xff8E96FF)),
              footer:
                  BallPulseFooter(color: Colors.red, enableInfiniteLoad: false),
              onLoad: null,
              onRefresh: () => controller.loadRefresh(),
              child: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 1.dp, horizontal: 0),
                  itemBuilder: (ctx, index) {
                    HistoryPo item = controller.state.histories[index];
                    return AudioItemWidget(
                      name: item.name,
                      picUrl: item.picUrl,
                      duration: item.duration,
                      singer: item.artistStr,
                      isChoose: controller.state.selectedIndex == index,
                      clickCallBack: () => controller.chooseSong(item, index),
                      moreCallBack: () {
                        // showModalBottomSheet(
                        //     context: ctx,
                        //     backgroundColor: Colors.white,
                        //     enableDrag: false,
                        //     builder: (BuildContext context) {
                        //       return Container(height: 200,width: 300, color: Colors.white,);
                        //     });
                        showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return Container(
                                height: 50,
                                width: 50,
                                color: Colors.white,
                              );
                            });
                      },
                    );
                  },
                  shrinkWrap: true,
                  primary: false,
                  itemCount: controller.state.histories.length,
                  separatorBuilder: (ctx, index) {
                    return SizedBox(
                      height: 1.dp,
                    );
                  },
                ),
              )));
    }
    return Container(
      color: const Color(0xffF6F8F9),
      child: Stack(
        children: [
          GetBuilder<FavoriteController>(builder: (logic) {
            return ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  scrollbars: true,
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 15.dp, horizontal: 0),
                  itemBuilder: (ctx, index) {
                    HistoryPo item = controller.state.histories[index];
                    return AudioItemWidget(
                      name: item.name,
                      picUrl: item.picUrl,
                      duration: item.duration,
                      singer: item.artistStr,
                      isChoose: controller.state.selectedIndex == index,
                      clickCallBack: () => controller.chooseSong(item, index),
                      moreCallBack: () {
                        // showModalBottomSheet(
                        //     context: ctx,
                        //     backgroundColor: Colors.white,
                        //     enableDrag: false,
                        //     builder: (BuildContext context) {
                        //       return Container(height: 200,width: 300, color: Colors.white,);
                        //     });

                        showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return Container(
                                height: 50,
                                width: 50,
                                color: Colors.white,
                              );
                            });
                      },
                    );
                  },
                  shrinkWrap: true,
                  primary: false,
                  itemCount: controller.state.histories.length,
                  separatorBuilder: (ctx, index) {
                    return const SizedBox(
                      height: 5,
                    );
                  },
                ));
          }),
          Positioned(
              bottom: 30,
              right: 30,
              child: BackButtonWidget(
                icon: Icons.refresh_rounded,
                clickCallBack: controller.fetchData,
              )),
        ],
      ),
    );
  }
}
