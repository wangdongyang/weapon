import 'package:flutter/material.dart';
import 'package:weapon/auto_ui.dart';

typedef OnChanged = Function(String text);
typedef StartSearch = Function();

class SearchWidget extends StatelessWidget {
  OnChanged? onChanged;
  StartSearch? start;
  final TextEditingController searchBarController = TextEditingController();
  final FocusNode searchFocus = FocusNode();

  SearchWidget({Key? key, this.onChanged, this.start}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: start,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(35.dp),
            ),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xFFF1F1F1).withAlpha(188),
                  offset: const Offset(6, 6),
                  blurRadius: 5.0,
                  spreadRadius: 0),
              BoxShadow(
                  color: const Color(0xFFF1F1F1).withAlpha(188),
                  offset: const Offset(-6, -6),
                  blurRadius: 5.0,
                  spreadRadius: 0)
            ]),
        height: 50.dp,
        // padding: EdgeInsets.symmetric(horizontal: 12.dp, vertical: 12.dp),
        child: Container(
          // height: SGScreenUtil.w(40),
          // decoration: BoxDecoration(
          //   color: const Color(0xFFF5F5F5),
          //   borderRadius: BorderRadius.all(
          //     Radius.circular(8.dp),
          //   ),
          // ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 24.dp,
              ),
              Container(
                // color: Colors.blue,
                child: Image.asset(
                  "assets/images/search_icon.png",
                  width: 18.sp,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                width: 20.dp,
              ),
              Expanded(
                // height: SGScreenUtil.h(40),
                child: TextField(
                  focusNode: searchFocus,
                  controller: searchBarController,
                  onChanged: onChanged,
                  enabled: start == null,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                      color: const Color(0xFF333333),
                      fontSize: 14.sp,
                      textBaseline: TextBaseline.alphabetic),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(
                        0, 0, 0, 0), //const EdgeInsets.all(0),
                    border: InputBorder.none,
                    hintText: "请输入...",
                    hintStyle:
                        TextStyle(color: Color(0xFF999999), fontSize: 13.sp),
                  ),
                ),
              ),
              // cancelWidget,
              SizedBox(
                width: 10.dp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
