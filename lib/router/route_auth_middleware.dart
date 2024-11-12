// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lease/main.dart';
// import 'package:lease/widget/widgets.dart';
//
// import '../common/utils/sp_utils.dart';
// import 'app_pages.dart';
//
// class RouteAuthMiddleware extends GetMiddleware {
//   RouteAuthMiddleware();
//
//   @override
//   RouteSettings? redirect(String? route){
//     print('object========redirect！${Global.login}');
//     if (!Global.login && Get.currentRoute != Routes.login) {
//       Widgets.showToastMsg('请先登录!',false);
//       return const RouteSettings(name: Routes.login);
//     }
//     return null;
//   }
// }
