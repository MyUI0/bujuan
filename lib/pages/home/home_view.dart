import 'package:bujuan/pages/play_widget/play_widget_view.dart';
import 'package:bujuan/utils/bujuan_util.dart';
import 'package:bujuan/widget/over_scroll.dart';
import 'package:bujuan/widget/preload_page_view.dart';
import 'package:bujuan/widget/timer/timer_count_down.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return _buildHomeView();
  }

  Widget _buildContent() {
    return OrientationBuilder(builder: (context,oritation){
      return oritation == Orientation.landscape?Row(
        children: [
          Expanded(child: Center(child: Text('data'),),flex: 1,),
          Expanded(child: ScrollConfiguration(
              behavior: OverScrollBehavior(),
              child: PreloadPageView.builder(
                onPageChanged: (index) => controller.onPageChange(index),
                controller: controller.pageController,
                preloadPagesCount: 2,
                itemBuilder: (context, index) => controller.pages[index],
                itemCount: controller.pages.length,
              )),flex: 3,)
        ],
      ):Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: ScrollConfiguration(
            behavior: OverScrollBehavior(),
            child: PreloadPageView.builder(
              onPageChanged: (index) => controller.onPageChange(index),
              controller: controller.pageController,
              preloadPagesCount: 2,
              itemBuilder: (context, index) => controller.pages[index],
              itemCount: controller.pages.length,
            )),
      );
    });
  }

  Widget _buildHomeView() {
    return PlayWidgetView(
      _buildContent(),
      isHome: true,
      appBar: _buildAppBar(),
    );
  }

  ///appBar
  Widget _buildAppBar() {
    return SafeArea(
        child: Container(
      height: 56.0,
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: Row(
        children: [
          Expanded(
              child: GetBuilder(
            builder: (_) => ListView.builder(
              itemBuilder: (context, index) {
                return InkWell(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 11.0),
                    child: Center(
                      child: Text(
                        controller.itmes[index],
                        style: TextStyle(
                            color: controller.currentIndex == index
                                ? Theme.of(context).bottomAppBarColor
                                : Colors.grey,
                            fontSize: 16,
                            fontWeight: controller.currentIndex == index
                                ? FontWeight.bold
                                : FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  onTap: () => controller.changeIndex(index),
                );
              },
              itemCount: controller.itmes.length,
              scrollDirection: Axis.horizontal,
            ),
            init: controller,
            id: 'bottom_bar',
          )),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: _buildSleepClock()),
          IconButton(icon: Icon(const IconData(0xe61b, fontFamily: 'iconfont')), onPressed: () {
            Get.toNamed('/search_details',arguments: {'content':''});
          }),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Get.toNamed('/setting');
            },
          )
        ],
      ),
    ));
  }

  ///睡眠按钮
  Widget _buildSleepClock() {
    return GetBuilder(
      builder: (_) {
        return InkWell(
          child: Row(
            children: [
              Padding(
                  padding: EdgeInsets.only(
                      right: controller.sleepTime > 0 ? 8.0 : 0),
                  child: Icon(
                    const IconData(0xe8ae, fontFamily: 'iconfont'),
                    size: 22.0,
                  )),
              Visibility(
                child: Countdown(
                  controller: HomeController.to.countdownController,
                  seconds: controller.sleepTime ~/ 1000,
                  build: (BuildContext context, double time) {
                    return Text(
                      '${BuJuanUtil.unix2Time(time.toInt())}',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    );
                  },
                  interval: Duration(milliseconds: 1000),
                  onFinished: () {
                    print('两分钟后停止');
                  },
                ),
                visible: controller.sleepTime > 0,
              )
            ],
          ),
          onTap: () => controller.showSleepBottomSheet(),
        );
      },
      init: HomeController.to,
      id: 'sleep',
    );
  }

}
