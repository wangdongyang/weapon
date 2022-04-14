import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:weapon/config/api_config.dart';
import 'package:weapon/home/songs_state.dart';
import 'package:weapon/model/song_list_item.dart';
import 'package:weapon/model/song_rank_model.dart';
import 'package:weapon/play/play_controller.dart';
import 'package:weapon/search/search_state.dart';
import 'package:weapon/utils/auth_util.dart';

class SongsController extends GetxController {
  SongsState state = SongsState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onClose() {
    print("SongsController onClose");
    super.onClose();
  }

  void addScrollListener() {
    //监听滚动条的滚动事件
    state.scrollController.addListener(() {
      if (state.scrollController.position.pixels ==
          state.scrollController.position.maxScrollExtent) {
        if (state.haveMore) {
          state.offset++;
          loadDataFromRank();
        }
      }
    });
  }

  loadData() async {
    var id = state.playListItem?.id;
    var dio = Dio();
    String host = Api.playlist;
    Map<String, dynamic> header = AuthUtil.getHeader(host);
    dio.options.headers = header;
    Map<String, dynamic> param = {
      "playlist_id": id,
      "source": "netease",
      "type": "playlist"
    };
    final response = await dio.get(host, queryParameters: param);
    List<dynamic> mapList = jsonDecode(response.toString());
    List<SongListItem> songs =
        mapList.map((e) => SongListItem.fromJson(e)).toList();
    state.songs = songs;
    update();
  }

  loadDataFromRank() async {
    var ranktype = state.rankListItem?.ranktype;
    var rankid = state.rankListItem?.rankid;
    var dio = Dio();
    String host = Api.rankSongsList;
    Map<String, dynamic> param = {
      "ranktype": ranktype,
      "rankid": rankid,
      "page": 0,
      "pagesize": 1000
    };
    print("param = $param");
    final response = await dio.get(host, queryParameters: param);
    String sst =
        response.toString().replaceAll(RegExp(r'<!--KG_TAG_RES_START-->'), "");
    sst = sst.replaceAll(RegExp(r'<!--KG_TAG_RES_END-->'), "");
    Map<String, dynamic> data = jsonDecode(sst);
    List dataList = data["data"]["info"];
    List<SongRankModel> ranks =
        dataList.map((e) => SongRankModel.fromJson(e)).toList();
    state.haveMore = dataList.length >= 20;
    if (state.offset == 0) {
      state.ranks = ranks;
    } else {
      state.ranks.addAll(ranks);
    }
    update();
  }

  chooseSong(SongListItem item, int index) {
    state.selectedIndex = index;
    Get.find<PlayController>().initSongListItem(item, AudioSource.netease);
    update();
  }

  chooseRankSong(SongRankModel item, int index) {
    state.selectedIndex = index;
    Get.find<PlayController>().initRangSong(item, AudioSource.kugou);
    update();
  }
}
