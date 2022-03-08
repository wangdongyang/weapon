import 'package:weapon/model/history_po.dart';
import 'package:weapon/model/play_list_item_model.dart';

class HomeState {
  HistoryPo? selectedItem;
  int selectedIndex = 0;

  List<HistoryPo> histories = [];

  List<PlayListItemModel> playList = [];
}
