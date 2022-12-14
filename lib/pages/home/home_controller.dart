import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:bujuan/common/audio_handler.dart';
import 'package:bujuan/common/constants/other.dart';
import 'package:bujuan/common/lyric_parser/parser_lrc.dart';
import 'package:bujuan/common/netease_api/netease_music_api.dart';
import 'package:bujuan/common/storage.dart';
import 'package:bujuan/pages/home/second/second_body_view.dart';
import 'package:bujuan/widget/weslide/weslide_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tabler_icons/tabler_icons.dart';
import 'package:tuna_flutter_range_slider/tuna_flutter_range_slider.dart';

import '../../common/lyric_parser/lyrics_reader_model.dart';

class HomeController extends SuperController with GetSingleTickerProviderStateMixin {
  final String weSlideUpdate = 'weSlide';

  //是否折叠
  RxBool isCollapsed = true.obs;
  WeSlideController weSlideController = WeSlideController();
  RxBool isCollapsedAfterSec = true.obs;
  RxInt selectIndex = 0.obs;

  RxDouble slidePosition = 0.0.obs;
  RxDouble slidePosition1 = 0.0.obs;
  Rx<PaletteColorData> rx = PaletteColorData().obs;
  RxBool isRoot = true.obs;
  RxBool second = false.obs;
  bool first = true;
  Rx<MediaItem> mediaItem = const MediaItem(id: '', title: '暂无', duration: Duration(seconds: 10)).obs;
  RxBool playing = false.obs;
  final OnAudioQuery audioQuery = GetIt.instance<OnAudioQuery>();
  late BuildContext buildContext;
  final AudioServeHandler audioServeHandler = GetIt.instance<AudioServeHandler>();
  Rx<Duration> duration = Duration.zero.obs;
  PanelController panelController = PanelController();
  bool isDownSlide = true;

  Rx<AudioServiceRepeatMode> audioServiceRepeatMode = AudioServiceRepeatMode.all.obs;
  Rx<AudioServiceShuffleMode> audioServiceShuffleMode = AudioServiceShuffleMode.none.obs;

  List<Map<dynamic, dynamic>> mEffects = [];
  double ellv = 30;
  double euuv = 60;
  AnimationController? animationController;
  RxInt sleep = 0.obs;
  String directoryPath = '';
  FixedExtentScrollController scrollController = FixedExtentScrollController();

  MyVerticalDragGestureRecognizer myVerticalDragGestureRecognizer = MyVerticalDragGestureRecognizer();

  RxBool needDrag = false.obs;

  //用户登录状态
  RxBool login = false.obs;
  ZoomDrawerController myDrawerController = GetIt.instance<ZoomDrawerController>();
  List<String> lyricList = <String>[].obs;
  List<LyricsLineModel> lyricsLineModels = <LyricsLineModel>[].obs;
  RxBool showPlayList = true.obs;

  //进度
  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    var rng = Random();
    for (double i = 0; i < 100; i++) {
      mEffects.add({"percent": i, "size": 5 + rng.nextInt(30 - 5).toDouble()});
    }
    animationController?.addListener(() {
      slidePosition1.value = animationController?.value ?? 0;
    });
    audioServeHandler.setRepeatMode(audioServiceRepeatMode.value);
    audioServeHandler.mediaItem.listen((value) async {
      if (value == null) return;
      //获取歌词
      SongLyricWrap songLyricWrap = await NeteaseMusicApi().songLyric(value.id ?? '');
      String lyric = songLyricWrap.lrc.lyric ?? "";
      lyricsLineModels
        ..clear()
        ..addAll(ParserLrc(lyric).parseLines());
      mediaItem.value = value;
      ImageUtils.getImageColor('${mediaItem.value.artUri?.scheme ?? ''}://${mediaItem.value.artUri?.host ?? ''}/${mediaItem.value.artUri?.path ?? ''}?param=50y50',
              (paletteColorData) {
            rx.value = paletteColorData;
          });
    });
    //监听实时进度变化
    AudioService.position.listen((event) {
      // if (first) duration.value = event;
      if (!weSlideController.isOpened) return;
      if (event.inMilliseconds > (mediaItem.value.duration?.inMilliseconds ?? 0)) {
        duration.value = Duration.zero;
        return;
      }
      duration.value = event;
      int index = lyricsLineModels.indexWhere((element) => (element.startTime ?? 0) >= event.inMilliseconds && (element.endTime ?? 0) <= event.inMilliseconds);
      if (index != -1) {
        scrollController.animateToItem(index > 0 ? index - 1 : index, duration: const Duration(milliseconds: 300), curve: Curves.linear);
      }
    });
    audioServeHandler.playbackState.listen((value) {
      playing.value = value.playing;
    });
  }

  static HomeController get to => Get.find();

  //改变循环模式
  changeRepeatMode() {
    switch (audioServiceRepeatMode.value) {
      case AudioServiceRepeatMode.one:
        audioServiceRepeatMode.value = AudioServiceRepeatMode.all;
        break;
      case AudioServiceRepeatMode.none:
        audioServiceRepeatMode.value = AudioServiceRepeatMode.one;
        break;
      case AudioServiceRepeatMode.all:
      case AudioServiceRepeatMode.group:
        audioServiceRepeatMode.value = AudioServiceRepeatMode.none;
        break;
    }
    audioServeHandler.setRepeatMode(audioServiceRepeatMode.value);
  }

  //改变随机模式
  changeShuffleMode() {
    // switch (audioServiceShuffleMode.value) {
    //   case AudioServiceShuffleMode.none:
    //     audioServiceShuffleMode.value = AudioServiceShuffleMode.all;
    //     break;
    //   case AudioServiceShuffleMode.all:
    //   case AudioServiceShuffleMode.group:
    //     audioServiceShuffleMode.value = AudioServiceShuffleMode.none;
    //     break;
    // }
    // audioServeHandler.setShuffleMode(audioServiceShuffleMode.value);
  }

  //获取当前循环icon
  IconData getRepeatIcon() {
    IconData icon;
    switch (audioServiceRepeatMode.value) {
      case AudioServiceRepeatMode.none:
        icon = TablerIcons.repeatOff;
        break;
      case AudioServiceRepeatMode.one:
        icon = TablerIcons.repeatOnce;
        break;
      case AudioServiceRepeatMode.all:
      case AudioServiceRepeatMode.group:
        icon = TablerIcons.repeat;
        break;
    }
    return icon;
  }

  //获取是否随机图标
  IconData getShuffleIcon() {
    IconData icon;
    switch (audioServiceShuffleMode.value) {
      case AudioServiceShuffleMode.none:
        icon = TablerIcons.arrowsShuffle;
        break;
      case AudioServiceShuffleMode.all:
      case AudioServiceShuffleMode.group:
        icon = Icons.shuffle_on;
        break;
    }
    return icon;
  }

  //播放 or 暂停
  void playOrPause() async {
    if (playing.value) {
      await audioServeHandler.pause();
    } else {
      await audioServeHandler.play();
    }
  }

  //改变panel位置
  void changeSlidePosition(value) {
    slidePosition.value = value;
    // if (second.value) second.value = false;
  }

  //当按下返回键
  Future<bool> onWillPop() async {
    if (panelController.isPanelOpen) {
      panelController.close();
      return false;
    }
    if (weSlideController.isOpened) {
      weSlideController.hide();
      return false;
    }
    return true;
  }

  //动态设置获取Header颜色
  Color getHeaderColor() {
    return Theme.of(buildContext).bottomAppBarColor.withOpacity(second.value
        ? 0
        : slidePosition.value > 0
            ? 0
            : 1);
  }

  //获取图片亮色背景下文字显示的颜色
  Color getLightTextColor() {
    if (slidePosition.value == 1) {
      return rx.value.light?.bodyTextColor ?? Colors.transparent;
    } else {
      return Theme.of(buildContext).iconTheme.color ?? Colors.transparent;
    }
  }

  //获取Header的padding
  EdgeInsets getHeaderPadding() {
    return EdgeInsets.only(
      left: 30.w,
      right: 30.w,
      top: MediaQuery.of(buildContext).padding.top * (second.value ? (1 - slidePosition.value) : slidePosition.value),
      bottom: slidePosition.value == 0 ? MediaQuery.of(buildContext).padding.bottom * .5 : 0,
    );
  }

  //当路由发生变化时调用
  void changeRoute(String? route) async {}

  List<FlutterSliderHatchMarkLabel> updateEffects(double leftPercent, double rightPercent) {
    List<FlutterSliderHatchMarkLabel> newLabels = [];
    for (Map<dynamic, dynamic> label in mEffects) {
      newLabels.add(FlutterSliderHatchMarkLabel());
    }
    return newLabels;
  }




  @override
  void onDetached() {
    // TODO: implement onDetached
  }

  @override
  void onInactive() {
    // TODO: implement onInactive
  }

  @override
  void onPaused() {
    // TODO: implement onPaused
  }

  @override
  void onResumed() {}
}
