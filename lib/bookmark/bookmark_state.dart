import 'package:weapon/model/bookmark_model.dart';

class BookmarkState {
  String url = "";
  List<BookMarkModel> data = [];
  int selectedIndex = 0;

  BookmarkState() {
    url = "https://gitee.com/mzxj/blog_pic/raw/master/json/bookmark.json";
    selectedIndex = 0;
  }
}
