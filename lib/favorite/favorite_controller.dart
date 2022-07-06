import 'package:get/get.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:weapon/favorite/favorite_state.dart';
import 'package:weapon/model/history_po.dart';
import 'package:weapon/play/play_controller.dart';
import 'package:weapon/utils/leancloud_util.dart';

class FavoriteController extends GetxController {
  FavoriteState state = FavoriteState();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    fetchData();
  }

  fetchData() async {
    // List<LCObject> results =
    //     await LeanCloudUtil.query(LeanCloudUtil.historyCN, 10);
    List<HistoryPo> histories = [];
    // for (LCObject element in results) {
    //   HistoryPo historyPo = HistoryPo.parse(element);
    //   histories.add(historyPo);
    // }



    state.histories = histories;
    update();
  }

  chooseSong(HistoryPo item, int index) {
    state.selectedIndex = index;
    Get.find<PlayController>().initState(state.histories, index);
  }
}
