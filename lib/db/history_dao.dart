import 'package:sqflite/sqflite.dart';
import 'package:weapon/model/history_po.dart';

class HistoryDao {
  final Database db;

  HistoryDao(this.db);

  Future<int> insert(HistoryPo history) async {
    //插入方法
    String addSql = //插入数据
        "INSERT INTO "
        "history(play_url,play_id,artist,source,pic_url,lyric_url,pic_id,lyric_id,name,size) "
        "VALUES (?,?,?,?,?,?,?,?,?,?);";
    return await db.transaction((tran) async => await tran.rawInsert(addSql, [
          history.playUrl,
          history.playId,
          history.artist,
          history.source,
          history.picUrl,
          history.lyricUrl,
          history.picId,
          history.lyricId,
          history.name,
          history.size
        ]));
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    return await db.rawQuery("SELECT * "
        "FROM history");
  }

  //根据 id 查询组件 node
  Future<List<Map<String, dynamic>>> queryById(int id) async {
    return await db.rawQuery(
        "SELECT play_url,artist,source,pic_url,lyric_url"
        "FROM history "
        "WHERE id = ? ORDER BY priority",
        [id]);
  }
}
