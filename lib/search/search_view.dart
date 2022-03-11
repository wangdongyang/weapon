import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weapon/auto_ui.dart';
import 'package:weapon/custom/audio_item_widget.dart';
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
                        clickCallBack: () => controller.chooseSong(item, index),
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
}
