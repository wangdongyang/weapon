import 'package:flutter/material.dart';

class BackgroundShower extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.20,
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bg2.png'),
                fit: BoxFit.cover),
            // borderRadius: BorderRadius.only(
            //     bottomRight: Radius.circular(400),
            //     topLeft: Radius.circular(400))
        ),
      ),
    );
  }
}
