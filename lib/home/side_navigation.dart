import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weapon/auto_ui.dart';
import 'package:weapon/model/btn_info.dart';
import 'package:weapon/typedef/function.dart';

///NavigationRail组件为侧边栏
class SideNavigation extends StatelessWidget {
  SideNavigation({
    required this.onItem,
    required this.selectedIndex,
    required this.sideItems,
    required this.isUnfold,
    required this.onUnfold,
    required this.isScale,
    required this.onScale,
  });

  ///侧边栏item
  final List<BtnInfo> sideItems;

  ///选择的index
  final int selectedIndex;
  final ParamSingleCallback onItem;

  ///是否展开  点击展开事件
  final bool isUnfold;
  final ParamSingleCallback<bool> onUnfold;

  ///缩放事件
  final bool isScale;
  final ParamSingleCallback<bool> onScale;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildTopLeading(),
          _buildItem(0),
          _buildItem(1),
          _buildItem(2),
        ],
      ),
    );
  }


  Widget _buildTopLeading() {
    return Center(
      child: Container(
        width: 50.dp,
        height: 50.dp,
        margin: const EdgeInsets.all(32.0),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              image: NetworkImage(
                  "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3383029432,2292503864&fm=26&gp=0.jpg"),
              fit: BoxFit.cover),
        ),
      ),
    );
  }


  Widget _buildItem(int index) {
    var item = sideItems[index];
    bool choose = selectedIndex == index;
    Image icon = choose
        ? Image.asset("assets/images/${item.icon}.png")
        : Image.asset("assets/images/${item.icon}_normal.png");
    Color color = choose ? const Color(0xFF0007F6) : const Color(0xFF768295);
    return GestureDetector(
      onTap: () => onItem(index),
      child: Container(
        height: 90.dp,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            choose
                ? Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(4.dp),
                            topRight: Radius.circular(4.dp)),
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xFF464BFA), Color(0xFF0007F6)],
                          tileMode: TileMode.repeated,
                        )
                        // boxShadow: [
                        //   BoxShadow(
                        //       color: const Color(0xFFF5F5F5).withAlpha(255),
                        //       offset: const Offset(-4, 0.0),
                        //       blurRadius: 5.0,
                        //       spreadRadius: 0)
                        // ],
                        // border: Border.all(width: 1,color: Colors.redAccent.withAlpha(100))
                        ),
                    width: 6.dp,
                    height: 55.dp,
                  )
                : Container(
                    width: 6.dp,
                  ),
            SizedBox(
              width: 50.dp,
            ),
            Row(
              children: [
                Container(
                    alignment: Alignment.center,
                    width: 20.dp,
                    height: 20.dp,
                    child: icon),
                SizedBox(
                  width: 14.dp,
                ),
                Text(
                  item.title ?? "",
                  style: TextStyle(color: color, fontSize: 15.sp),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
