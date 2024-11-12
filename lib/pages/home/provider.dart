import 'package:bujuan_music_api/api/user/entity/user_info_entity.dart';
import 'package:bujuan_music_api/bujuan_music_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/request_state.dart';

class HomeRequestState extends RequestState<HomeData> {
  HomeRequestState({super.isLoading, super.data, super.isError, super.isEmpty});

  @override
  HomeRequestState copyWith(
      {bool? isLoading,
      HomeData? data,
      bool? isError,
      bool? isEmpty,
      TabController? tabControllerFirst,
      TabController? tabControllerSecond}) {
    return HomeRequestState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      isError: isError ?? this.isError,
      isEmpty: isEmpty ?? this.isEmpty,
    );
  }
}

class HomeData {
  final UserInfoEntity? userInfo;

  HomeData({this.userInfo});

  HomeData copyWith({UserInfoEntity? userInfo}) {
    return HomeData(
      userInfo: userInfo ?? this.userInfo,
    );
  }
}

//定义 StateNotifier
class HomeRequestNotifier extends StateNotifier<HomeRequestState> {
  HomeRequestNotifier() : super(HomeRequestState()) {
    _fetchData();
  }


  refresh({bool showLoading = false}) async {
    await _fetchData(showLoading: showLoading, refresh: true);
    return true;
  }

  Future<void> _fetchData({bool? showLoading, bool? refresh = false}) async {
    if (showLoading ?? true) {
      state = state.copyWith(isLoading: showLoading ?? true);
    }
    try {
      final userInfo = BujuanMusicManager().userInfo();
      final requestedList = await Future.wait([userInfo]);

      final userInfoResponse = requestedList[0];

      if (userInfoResponse == null) {
        if (refresh ?? false) return;
        throw Exception('加载失败');
      }
      final homeData = HomeData(userInfo: userInfoResponse);
      state = state.copyWith(isLoading: false, data: homeData, isError: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, isError: true);
    }
  }
}

// 创建 StateNotifierProvider
final homeProvider =
    StateNotifierProvider.autoDispose<HomeRequestNotifier, HomeRequestState>((ref) {
  ref.onDispose(() {
    if (kDebugMode) {
      print('首页页面Provider被销毁了========');
    }
  });
  return HomeRequestNotifier();
});
