import 'package:bujuan/router/app_pages.dart';
import 'package:bujuan_music_api/bujuan_music_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

import 'common/utils/adaptive_screen_utils.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initMain();
  final router = GoRouter(
      navigatorKey: rootNavigatorKey, initialLocation: Routes.home, routes: AppPages.pages);
  runApp(Builder(builder: (BuildContext context) {
    final desktop = expanded(context);
    final tablet = medium(context);
    bool land = desktop || tablet;
    if (land) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    }
    return ScreenUtilInit(
      designSize: land ? const Size(1920, 1080) : const Size(750, 1334),
      child: ProviderScope(
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );
  }));
}

_initMain() async {
  //初始化音乐服务
  final appDocDir = await getApplicationDocumentsDirectory();
  await BujuanMusicManager().init(cookiePath: '${appDocDir.path}/cookies', debug: true);
}
