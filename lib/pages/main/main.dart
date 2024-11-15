import 'package:bujuan/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class MainPage extends StatefulWidget {
  final Widget body;

  const MainPage({super.key, required this.body});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      borderRadius: 24.0,
      showShadow: true,
      angle: 0,
      mainScreenScale: .01,
      drawerShadowsBackgroundColor: Colors.grey.withOpacity(.3),
      isRtl: true,
      slideWidth: MediaQuery.of(context).size.width -100.w,
      openCurve: Curves.fastOutSlowIn,
      closeCurve: Curves.bounceIn,
      menuScreen: Container(),
      mainScreen: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [const Color(0xFF6C63FF).withOpacity(.3), Colors.white.withOpacity(.4)])),
          child: Row(
            children: [
              Expanded(child: widget.body),
              Card(
                margin: EdgeInsets.all(5.w),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r)
                ),
                child: Container(
                  width: 90.w,
                  height: MediaQuery.of(context).size.height,
                  child: const Column(
                    children: [Text('data')],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
