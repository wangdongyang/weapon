import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weapon/auto_ui.dart';
import 'package:weapon/custom/audio_item_widget.dart';
import 'package:weapon/home/songs_controller.dart';
import 'package:weapon/home/songs_state.dart';
import 'package:weapon/model/play_list_item_model.dart';
import 'package:weapon/model/song_list_item.dart';
import 'package:weapon/utils/navigator_util.dart';

class SongsView extends StatefulWidget {
  PlayListItemModel? playListItem;

  SongsView({Key? key, this.playListItem}) : super(key: key);

  @override
  _SongsViewState createState() => _SongsViewState();
}

class _SongsViewState extends State<SongsView> {
  final SongsController controller = Get.put(SongsController());

  @override
  void initState() {
    super.initState();

    controller.state.playListItem = widget.playListItem;
    controller.loadData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    /// 因为要在中间部分做页面跳转，没有用到Getx.toName, 所以SongsController没有销毁，需手动清除数据。
    controller.state = SongsState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffF6F8F9),
      child: GetBuilder<SongsController>(builder: (logic) {
        return ScrollConfiguration(
            behavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: ListView.separated(
              padding: EdgeInsets.symmetric(
                  vertical: 15.dp, horizontal: 0),
              itemBuilder: (ctx, index) {
                SongListItem item = controller.state.songs[index];
                return AudioItemWidget(
                  name: item.name,
                  picUrl: item.picUrl,
                  duration: item.dt,
                  artist: item.artist,
                  isChoose: controller.state.selectedIndex == index,
                  clickCallBack: ()=>controller.chooseSong(item, index),
                );
              },
              shrinkWrap: true,
              primary: false,
              itemCount: controller.state.songs.length,
              separatorBuilder: (ctx, index) {
                return const SizedBox(
                  height: 5,
                );
              },
            ));
      }),
    );
  }
}
