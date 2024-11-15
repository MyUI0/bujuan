import 'package:bujuan/pages/home/desktop.dart';
import 'package:bujuan/pages/home/mobile.dart';
import 'package:flutter/cupertino.dart';

import '../../common/utils/adaptive_screen_utils.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final desktop = expanded(context);
    final tablet = medium(context);
    bool land = desktop || tablet;
    return land ? const HomeDesktop() : const HomeMobile();
  }
}
