import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weapon/auto_ui.dart';
import 'package:weapon/base/base_scaffold.dart';
import 'package:weapon/bookmark/bookmark_controller.dart';
import 'package:weapon/model/bookmark_model.dart';

class BookMarkPage extends StatefulWidget {
  const BookMarkPage({Key? key}) : super(key: key);

  @override
  _BookMarkPageState createState() => _BookMarkPageState();
}

class _BookMarkPageState extends State<BookMarkPage> {
  final BookmarkController controller = Get.put(BookmarkController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookmarkController>(
      builder: (logic) {
        if (logic.state.data.isEmpty) return Container();
        int gridCount =
            logic.state.data[logic.state.selectedIndex].items?.length ?? 0;
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  height: 50.0,
                  // width: 500,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: logic.state.data.length,
                    separatorBuilder: (ctx, index) {
                      return Container(
                        width: 20,
                      );
                    },
                    itemBuilder: (context, index) {
                      var bookMarkModel = logic.state.data[index];
                      bool selected = logic.state.selectedIndex == index;
                      Color borderColor =
                          selected ? Colors.pink : Colors.black26;
                      return GestureDetector(
                        child: Container(
                          height: 100.0,
                          width: 100,
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: borderColor),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8))),
                          alignment: Alignment.center,
                          child: Text(
                            bookMarkModel.name ?? "",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        onTap: () {
                          logic.updateSelectedIndex(index);
                        },
                      );
                    },
                  ),
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(top: 15)),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 1.3,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    BookMarkItem? item = logic
                        .state.data[logic.state.selectedIndex].items?[index];
                    if (item == null) return Container();
                    return GestureDetector(
                      onTap: () => logic.openUrl(item.url),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(16),
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0xFFEEEEEE).withAlpha(255),
                                  offset: const Offset(0, 2.0),
                                  blurRadius: 8.0,
                                  spreadRadius: 0)
                            ]),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              item.icon != null
                                  ? const SizedBox(
                                      width: 10,
                                    )
                                  : Container(),
                              item.icon != null
                                  ? Container(
                                      width: 40.dp,
                                      height: 40.dp,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(40),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                                color: const Color(0xFFcccccc)
                                                    .withAlpha(255),
                                                offset: const Offset(0, 2.0),
                                                blurRadius: 5.0,
                                                spreadRadius: 0)
                                          ]
                                          // border: Border.all(width: 1,color: Colors.redAccent.withAlpha(100))
                                          ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(40),
                                        child: toImage(item.icon),
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                width: 10.dp,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(item.title ?? "",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.dp,
                                        )),
                                    SizedBox(
                                      height: 5.dp,
                                    ),
                                    Text(item.desc ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.black38,
                                          fontSize: 13.dp,
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: gridCount,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget toImage(String? url) {
    if (url == null) return Container();
    if (url.contains("http")) {
      return Image(
        width: 40.dp,
        height: 40.dp,
        image: NetworkImage(url),
        fit: BoxFit.contain,
      );
    }
    return Center(
      child: Text(url,
          style: TextStyle(
              color: Color.fromRGBO(Random().nextInt(256),
                  Random().nextInt(256), Random().nextInt(256), 1),
              fontSize: 17.dp,
              fontWeight: FontWeight.bold)),
    );
  }
}
