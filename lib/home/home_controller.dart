import 'package:get/get.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:weapon/home/home_state.dart';
import 'package:weapon/model/history_po.dart';
import 'package:weapon/play/play_controller.dart';
import 'package:weapon/utils/leancloud_util.dart';

class HomeController extends GetxController{

  HomeState state = HomeState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    loadData();
  }

  loadData() async {
    // LCUser user = LCUser();
    // user.signUp();
    // LCUser.loginByMobilePhoneNumber(username, password);

    List<LCObject> results =
    await LeanCloudUtil.query(LeanCloudUtil.historyCN, 10);
    List<HistoryPo> histories = [];
    for (LCObject element in results) {
      HistoryPo historyPo = HistoryPo.parse(element);
      histories.add(historyPo);
    }
    state.histories = histories;
    update();
  }


  chooseSong(HistoryPo item, int index) {
    state.selectedItem = item;
    state.selectedIndex = index;
    Get.find<PlayController>().initState(item);
    update();
  }
}