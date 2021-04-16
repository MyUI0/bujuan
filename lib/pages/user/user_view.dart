import 'package:bujuan/entity/personal_entity.dart';
import 'package:bujuan/entity/user_order_entity.dart';
import 'package:bujuan/global/global_config.dart';
import 'package:bujuan/global/global_controller.dart';
import 'package:bujuan/pages/sheet_info/head.dart';
import 'package:bujuan/utils/net_util.dart';
import 'package:bujuan/widget/over_scroll.dart';
import 'package:bujuan/pages/user/user_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_placeholder_textlines/placeholder_lines.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:starry/starry.dart';

class UserView extends GetView<UserController> {
  @override
  Widget build(BuildContext context) {
    return _buildLoginView(context);
  }

  ///展示我的歌单
  Widget _buildLoginView(context) {
    return ScrollConfiguration(
      behavior: OverScrollBehavior(),
      child: Obx(() => SmartRefresher(
            header: WaterDropMaterialHeader(
              color: Theme.of(context).accentColor,
              backgroundColor: Theme.of(context).primaryColor,
            ),
            controller: controller.refreshController,
            onRefresh: () => controller.getUserSheet(forcedRefresh: true),
            child: CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  delegate: SliverAppBarDelegate(
                      minHeight: 90.0,
                      maxHeight: 90.0,
                      child: Card(
                        child: Padding(padding: EdgeInsets.symmetric(horizontal: 10.0),child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                IconButton(
                                    icon: Icon(
                                      IconData(0xec9f, fontFamily: 'iconfont'),
                                      color: Colors.red,
                                    ),
                                    onPressed: () => Get.toNamed('/radio')),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 12.0),
                                  child: Text(
                                    '电台',
                                    style: TextStyle(fontSize: 12.0),
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                IconButton(
                                    icon: Icon(
                                      IconData(0xe62a, fontFamily: 'iconfont'),
                                      color: Colors.red,
                                    ),
                                    onPressed: () => Get.toNamed('/cloud')),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 12.0),
                                  child: Text(
                                    '云盘',
                                    style: TextStyle(fontSize: 12.0),
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                IconButton(
                                    icon: Icon(
                                      IconData(0xe607, fontFamily: 'iconfont'),
                                      color: Colors.red,
                                      size: 26.0,
                                    ),
                                    onPressed: () {
                                      if (GlobalController
                                          .to.playListMode.value !=
                                          PlayListMode.FM) {
                                        controller.getFM();
                                      }
                                    }),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 12.0),
                                  child: Text(
                                    '私人Fm',
                                    style: TextStyle(fontSize: 12.0),
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                IconButton(
                                    icon: Icon(
                                      IconData(0xe619, fontFamily: 'iconfont'),
                                      color: Colors.red,
                                    ),
                                    onPressed: () => Get.toNamed('/history')),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 12.0),
                                  child: Text(
                                    '记录',
                                    style: TextStyle(fontSize: 12.0),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),),
                      )),
                  floating: true,
                ),
                SliverPadding(padding: EdgeInsets.symmetric(vertical: 8.0)),
                SliverFixedExtentList(
                  itemExtent: 60.0,
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return controller.lovePlayList.length > 0
                          ? _buildUserSheetItem(controller.lovePlayList[index],
                              isLike: true)
                          : _loadUserSheetView();
                    },
                    childCount: controller.lovePlayList.length > 0
                        ? controller.lovePlayList.length
                        : 1,
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                    child: Text(
                      "我创建的",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                controller.isNoCreate.value
                    ? SliverToBoxAdapter(
                        child: Container(
                          height: 80.0,
                          child: Center(
                            child: Wrap(
                              children: [
                                Icon(Icons.sentiment_neutral_outlined),
                                Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 6.0)),
                                Text('暂无收藏歌单')
                              ],
                            ),
                          ),
                        ),
                      )
                    : SliverFixedExtentList(
                        itemExtent: 60.0,
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return controller.createPlayList.length > 0
                                ? _buildUserSheetItem(
                                    controller.createPlayList[index])
                                : _loadUserSheetView();
                          },
                          childCount: controller.createPlayList.length > 0
                              ? controller.createPlayList.length
                              : 5,
                        ),
                      ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                    child: Text(
                      "我收藏的",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                controller.isNoCollect.value
                    ? SliverToBoxAdapter(
                        child: Container(
                          height: 80.0,
                          child: Center(
                            child: Wrap(
                              children: [
                                Icon(Icons.sentiment_neutral_outlined),
                                Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 6.0)),
                                Text('暂无收藏歌单')
                              ],
                            ),
                          ),
                        ),
                      )
                    : SliverFixedExtentList(
                        itemExtent: 60.0,
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return controller.collectPlayList.length > 0
                                ? _buildUserSheetItem(
                                    controller.collectPlayList[index])
                                : _loadUserSheetView();
                          },
                          childCount: controller.collectPlayList.length > 0
                              ? controller.collectPlayList.length
                              : 5,
                        ),
                      ),
              ],
            ),
          )),
    );
  }

  ///歌单itemView
  Widget _buildUserSheetItem(UserOrderPlaylist userOrderPlaylist,
      {isLike = false}) {
    return InkWell(
      child: Container(
        height: 60.0,
        padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 5.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 12.0),
              child: Hero(
                tag: '${userOrderPlaylist.id}',
                child: Card(
                  child: CachedNetworkImage(
                    width: 42,
                    height: 42,
                    imageUrl: '${userOrderPlaylist.coverImgUrl}?param=100y100',
                  ),
                ),
              ),
            ),
            Expanded(
                child: Column(
              children: [
                Container(
                  height: 25,
                  alignment: Alignment.centerLeft,
                  child: Text(userOrderPlaylist.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16.0)),
                ),
                Container(
                  height: 25,
                  alignment: Alignment.centerLeft,
                  child: Text('${userOrderPlaylist.trackCount}首',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 14.0, color: Colors.grey[500])),
                )
              ],
            )),
            Visibility(
                child: Card(
                  child: InkWell(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                      child: Wrap(
                        children: [
                          Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0)),
                          Text('心动模式')
                        ],
                      ),
                    ),
                    onTap: () => controller.playHeartSong(userOrderPlaylist.id),
                  ),
                ),
                visible: isLike),
            Padding(padding: EdgeInsets.symmetric(horizontal: 4.0))
          ],
        ),
      ),
      onTap: () {
        Get.toNamed('/sheet', arguments: {
          'sheet': PersonalResult(
              id: userOrderPlaylist.id,
              name: userOrderPlaylist.name,
              picUrl: '${userOrderPlaylist.coverImgUrl}'),
        });
      },
    );
  }

  ///歌单加载中View
  Widget _loadUserSheetView() {
    return Container(
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(right: 12.0),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(.6),
                borderRadius: BorderRadius.circular(6.0)),
            child: Center(
              child: Icon(
                Icons.photo_size_select_actual,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          Expanded(
              child: PlaceholderLines(
            lineHeight: 10.0,
            count: 2,
          )),
        ],
      ),
    );
  }
}
