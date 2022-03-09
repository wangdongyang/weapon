import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:weapon/auto_ui.dart';
import 'package:weapon/config/api_config.dart';
import 'package:weapon/home/home_state.dart';
import 'package:weapon/main/main_controller.dart';
import 'package:weapon/model/history_po.dart';
import 'package:weapon/model/play_list_item_model.dart';
import 'package:weapon/model/song_list_item.dart';
import 'package:weapon/play/play_controller.dart';
import 'package:weapon/search/search_state.dart';
import 'package:weapon/utils/auth_util.dart';
import 'package:weapon/utils/leancloud_util.dart';

class SearchController extends GetxController {
  SearchState state = SearchState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    _updateSubRouteMenuItems();
  }

  void _updateSubRouteMenuItems() {
    state.subRouteNameMenuItems = state.sources
        .map<DropdownMenuItem<String>>((Map<String, dynamic> route) {
      return DropdownMenuItem(
        value: route["name"],
        onTap: () {
          state.audioSource = route["source"];
          update();
        },
        child: Container(
          color: Colors.white,
          child: Text(
            route["name"],
            style: TextStyle(
              color: const Color(0xFF333333),
              fontSize: 12.sp,
            ),
          ),
        ),
      );
    }).toList();
  }

  search() async {
    String text = state.searchBarController.value.text;
    if (text.isEmpty) return;
    var dio = Dio();
    String host = Api.music;
    Map<String, dynamic> header = AuthUtil.getHeader(host);
    dio.options.headers = header;
    Map<String, dynamic> param = {
      "keyword": text,
      "site": state.audioSource.toString().split(".").last
    };
    final response = await dio.get(host, queryParameters: param);
    print("param:$param; response: $response");
    List<dynamic> mapList = jsonDecode(response.toString());
    List<SongListItem> songs = [];
    for (var element in mapList) {
      songs.add(SongListItem.fromJson(element));
    }
    state.songs = songs;
    update();
  }

  chooseSong(HistoryPo item, int index) {
    state.selectedItem = item;
    state.selectedIndex = index;
    Get.find<PlayController>().initState(item);
    update();
  }

  startSearch() {
    Get.find<MainController>().switchTap(1);
  }

  menuChanged(text) {
    state.selectedName = text;
    update();
  }
}
