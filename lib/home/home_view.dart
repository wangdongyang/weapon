import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:weapon/base/base_scaffold.dart';
import 'package:weapon/custom/background_shower.dart';
import 'package:weapon/home/home_drawer.dart';
import 'package:weapon/home/home_controller.dart';
import 'package:weapon/home/home_state.dart';
import 'package:weapon/home/side_navigation.dart';
import 'package:weapon/play/play_controller.dart';
import 'package:weapon/play/play_view.dart';
import 'package:weapon/utils/audio_player_util.dart';

class HomePage extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  final PlayController playController = Get.put(PlayController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      backgroundColor: Colors.white,
      drawer: const HomeDrawer(),
      body: Row(children: [
        ///侧边栏区域
        GetBuilder<HomeController>(
          builder: (logic) {
            return Expanded(
              flex: 3,
              child: SideNavigation(
                selectedIndex: logic.state.selectedIndex,
                isUnfold: logic.state.isUnfold,
                isScale: logic.state.isScale,
                sideItems: logic.state.itemList,
                onItem: (index) => logic.switchTap(index),
                onUnfold: (isUnfold) => logic.onUnfold(isUnfold),
                onScale: (isScale) => logic.onScale(isScale),
              ),
            );
          },
        ),

        ///Expanded占满剩下的空间
        Expanded(
          flex: 9,
          child: Stack(
            children: [
              _buildBackground(),
              PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.state.pageList.length,
                itemBuilder: (context, index) =>
                    controller.state.pageList[index],
                controller: controller.state.pageController,
              )
            ],
          ),
        ),
        GetBuilder<PlayController>(
          builder: (controller) {
            return Expanded(
                flex: 3,
                child: PlayView(
                  name: playController.state.name,
                  picUrl: playController.state.picUrl,
                  artist: playController.state.artist,
                  lyricWidget: playController.state.lyricWidget,
                  playerState: playController.state.playerState,
                  lyrics: playController.state.lyrics,
                  duration: playController.state.duration,
                  position: playController.state.position,
                  lyricOffsetYController:
                  playController.state.lyricOffsetYController,
                  dragEndTimer: playController.state.dragEndTimer,
                ));
          },
        ),

      ]),
    );
  }

  Widget _buildBackground() {
    return BackgroundShower();
  }

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     extendBody: true,
//     drawer: const HomeDrawer(),
//     body: Builder(
//       builder: (context) =>
//           Center(
//             child: RaisedButton(
//               color: Colors.pink,
//               textColor: Colors.white,
//               onPressed: (){
//                 Scaffold.of(context).openDrawer();
//               },
//               child: Text('Display SnackBar'),
//             ),
//           ),
//     ),
//     // bottomNavigationBar: _buildBottomNav(context),
//   );
// }
}
