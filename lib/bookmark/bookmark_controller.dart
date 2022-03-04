import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weapon/bookmark/bookmark_state.dart';
import 'package:weapon/config/init_config.dart';
import 'package:weapon/main/main_state.dart';
import 'package:weapon/model/bookmark_model.dart';

class BookmarkController extends GetxController {
  final state = BookmarkState();

  @override
  void onInit() {
    super.onInit();

    getData();
  }

  getData() async {
    var dio = Dio();
    final response = await dio.get(state.url);
    List<BookMarkModel> data = [];
    List list = jsonDecode(response.data);
    for (var element in list) {
      data.add(BookMarkModel.fromJson(element));
    }
    state.data = data;
    update();
  }

  openUrl(String? url) {
    if (url == null) return;
    launch(url);
  }

  void updateSelectedIndex(int index) {
    state.selectedIndex = index;
    update();
  }
}
