import 'package:auto_route/auto_route.dart';
import 'package:bujuan/pages/home/home_controller.dart';
import 'package:bujuan/pages/user/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tabler_icons/tabler_icons.dart';

import '../../../widget/simple_extended_image.dart';

class MenuView extends GetView<HomeController> {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        Padding(padding: EdgeInsets.symmetric(vertical: 25.w)),
        Obx(() => SimpleExtendedImage.avatar(
              UserController.to.loginStatus.value ? UserController.to.userData.value.profile?.avatarUrl ?? '' : '',
              width: 200.w,
            )),
        Expanded(
            child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 140.w),
          itemBuilder: (context, index) => InkWell(
            child: Obx(() => Container(
                  padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 32.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 8.w,
                        height: 50.w,
                        color: controller.currPathUrl.value == controller.leftMenus[index].pathUrl ? Theme.of(context).primaryColor : Colors.transparent,
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 10.w)),
                      Icon(controller.leftMenus[index].icon,
                          color: controller.currPathUrl.value == controller.leftMenus[index].pathUrl ? Theme.of(context).primaryColor : controller.getLeftMenuColor()),
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.only(left: 30.w, top: 8.w),
                        child: Text(
                          controller.leftMenus[index].title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: controller.currPathUrl.value == controller.leftMenus[index].pathUrl ? Theme.of(context).primaryColor : controller.getLeftMenuColor()),
                        ),
                      )),
                    ],
                  ),
                )),
            onTap: () {
              controller.myDrawerController.close!();
              Future.delayed(const Duration(milliseconds: 400), () => context.router.replaceNamed(controller.leftMenus[index].path));
            },
          ),
          itemCount: controller.leftMenus.length,
        )),
        ListTile(
          leading: Icon(TablerIcons.login,color: controller.getLeftMenuColor()),
          title: Text(
            '注销登陆',
            style: TextStyle(color: controller.getLeftMenuColor()),
          ),
          onTap: () {
            controller.myDrawerController.close!();
            Future.delayed(const Duration(milliseconds: 400), () => UserController.to.clearUser());
          },
        )
      ],
    ));
  }
}
