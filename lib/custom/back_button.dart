import 'package:flutter/material.dart';
import 'package:weapon/auto_ui.dart';

class BackButtonWidget extends StatelessWidget {
  Function clickCallBack;
  IconData icon = Icons.arrow_back_sharp;

  BackButtonWidget({Key? key, required this.clickCallBack, this.icon = Icons.arrow_back_sharp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        clickCallBack();
      },
      child: Container(
        height: 60.dp,
        width: 60.dp,
        decoration: BoxDecoration(
            color: const Color(0xffFFFFFF),
            borderRadius: BorderRadius.circular(60.dp),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xffd2d2d2).withAlpha(120),
                  offset: const Offset(4, 4),
                  blurRadius: 5.0,
                  spreadRadius: 0)
            ]),
        child: Icon(
          icon,
          size: 22.sp,
          color: const Color(0xffc1c1c1),
        ),
      ),
    );
  }
}
