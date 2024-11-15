import 'package:bujuan/pages/main/main.dart';
import 'package:bujuan/router/app_pages.dart';
import 'package:bujuan_music_api/bujuan_music_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:flutter_acrylic/window.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';

import 'common/utils/adaptive_screen_utils.dart';

final isLand = Provider.family<bool, BuildContext>((ref, context) {
  final desktop = expanded(context);
  final tablet = medium(context);
  return desktop || tablet;
});

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initMain();
  await windowManager.ensureInitialized();
  await Window.initialize();
  await Window.setEffect(effect: WindowEffect.transparent);
  // 设置窗口属性
  windowManager.setSize(const Size(1200, 800));
  windowManager.setResizable(false);
  windowManager.setTitleBarStyle(TitleBarStyle.hidden);

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    // 沉浸式状态栏（仅安卓）
    statusBarColor: Colors.transparent,
    // 沉浸式导航指示器
    systemNavigationBarColor: Colors.transparent,
  ));
  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: Routes.main,
    routes: AppPages.pages,
  );
  runApp(Builder(builder: (BuildContext context) {
    final desktop = expanded(context);
    final tablet = medium(context);
    bool land = desktop || tablet;
    if (land) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    }
    return ScreenUtilInit(
      designSize: land ? const Size(1200, 800) : const Size(750, 1334),
      child: ProviderScope(
        child: MaterialApp.router(
          color: Colors.transparent,
          // theme: ThemeData.light().copyWith(scaffoldBackgroundColor: Colors.transparent),
          showPerformanceOverlay: false,
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
