import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:weapon/home/playlist/play_list_controller.dart';

class PlayListView extends StatefulWidget {
  const PlayListView({Key? key}) : super(key: key);

  @override
  _PlayListViewState createState() => _PlayListViewState();
}

class _PlayListViewState extends State<PlayListView> {
  final PlayListController controller = Get.put(PlayListController());

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("PlayListView dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
