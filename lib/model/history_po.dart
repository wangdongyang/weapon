import 'dart:convert';

import 'package:leancloud_storage/leancloud.dart';
import 'package:weapon/model/song_list_item.dart';
import 'package:weapon/utils/leancloud_util.dart';
import 'package:weapon/utils/lyric_util.dart';

class HistoryPo {
  String playUrl = "";
  String playId = "";
  List<ArtistModel> artist = [];
  String source = "";
  String picUrl = "";
  String lyricUrl = "";
  String picId = "";
  String lyricId = "";
  String name = "";
  int size = 0;
  int id = 0;
  int dt = 0;

  HistoryPo();

  HistoryPo.parse(LCObject lcObject) {
    playUrl = lcObject["playUrl"];
    playId = lcObject["playId"];
    List<Map<String, dynamic>> artistMaps =
        jsonDecode(lcObject["artist"]).cast<Map<String, dynamic>>();
    List<ArtistModel> artists = [];
    for (var element in artistMaps) {
      artists.add(ArtistModel.fromJson(element));
    }
    artist = artists;
    source = lcObject["source"];
    picUrl = lcObject["picUrl"];
    lyricUrl = lcObject["lyricUrl"];
    picId = lcObject["picId"];
    lyricId = lcObject["lyricId"];
    name = lcObject["name"];
    size = lcObject["size"];
    if (lcObject["dt"] != null) {
      dt = int.parse(lcObject["dt"].toString());
    }
  }

  Future<void> saveData() async {
    LCObject lcObject = LCObject(LeanCloudUtil.historyCN);
    lcObject["playUrl"] = playUrl;
    lcObject["playId"] = playId;
    List<Map<String, dynamic>> artistMaps = [];
    for (var element in artist) {
      artistMaps.add(element.toJson());
    }
    lcObject["artist"] = jsonEncode(artistMaps);
    lcObject["source"] = source;
    lcObject["picUrl"] = picUrl;
    lcObject["lyricUrl"] = lyricUrl;
    lcObject["picId"] = picId;
    lcObject["lyricId"] = lyricId;
    lcObject["name"] = name;
    lcObject["size"] = size;
    lcObject["dt"] = dt;

    var findOneMusic = await LeanCloudUtil.findOneMusic(playId, source);
    if (findOneMusic.isEmpty) {
      await lcObject.save();
    } else {
      print("$playId:$name已经存在了");
    }
    // LocalDb.instance.historyDao.insert(po);
  }
}
