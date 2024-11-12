import 'package:bujuan/common/request_state.dart';
import 'package:bujuan/common/values/icons.dart';
import 'package:bujuan/main.dart';
import 'package:bujuan/pages/home/provider.dart';
import 'package:bujuan/widgets/image.dart';
import 'package:bujuan_music_api/api/recommend/entity/recommend_resource_entity.dart';
import 'package:bujuan_music_api/api/top/entity/top_artist_entity.dart';
import 'package:bujuan_music_api/bujuan_music_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with SingleTickerProviderStateMixin{
  late HomeRequestNotifier controller;
  late AnimationController animationController;
  @override
  void initState() {
    controller = ref.read(homeProvider.notifier);
    animationController = AnimationController(vsync: this);
    animationController.addListener((){
      print('object=====================================${animationController.value}');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        actions: [
          IconButton(
              onPressed: () {},
              icon:
              ImageView(url: AppIcons.message, width: 50.w, height: 50.w)),
          IconButton(
            onPressed: () {},
            icon: ImageView(
                url:
                "https://p2.music.126.net/VxlVtJCnBkHmyoY6PbnNOA==/109951169548313443.jpg",
                isCircle: true,
                width: 80.w,
                height: 80.w,
                cornerRadius: 40.r),
            padding: const EdgeInsets.symmetric(vertical: 0),
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: BaseRequestWidget<HomeData>(
                requestState: ref.watch(homeProvider),
                childBuilder: (HomeData data) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Column(
                      children: [
                        _buildArtistsWidget(data.topArtists!.artists),
                        SizedBox(height: 20.h),
                        _buildRecommendWidget(data.recommendResource!.recommend)
                      ],
                    ),
                  );
                }),
          ),
          Positioned(
            bottom: 30.w,
            child: GestureDetector(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.r)),
                height: 140.w,
                width: 710.w,
                child: Row(
                  children: [
                    Hero(tag: 'images', child: ImageView(url: 'https://p2.music.126.net/VxlVtJCnBkHmyoY6PbnNOA==/109951169548313443.jpg',width: 100.w,height: 100.w,cornerRadius: 10.r,))
                  ],
                ),
              ),
              onTap: () {
                showCupertinoModalBottomSheet(
                  context: context,
                  builder: (c) => PlayListView(),
                  backgroundColor: Colors.white,
                  closeProgressThreshold: 0.5,
                  expand: true,
                  secondAnimation: animationController
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildArtistsWidget(List<TopArtistArtists> artists) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 20.w, left: 15.w, right: 15.w),
          child: Text(
            'Top Artist',
            style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(
          height: 200.w,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ImageView(
                    url: artists[index].img1v1Url ?? "",
                    width: 130.w,
                    height: 130.w,
                    cornerRadius: 65.r,
                    isCircle: true,
                  ),
                  SizedBox(height: 10.w),
                  Text(
                    artists[index].name,
                    style: TextStyle(fontSize: 24.sp),
                  )
                ],
              ),
            ),
            itemCount: artists.length > 10 ? 10 : artists.length,
          ),
        )
      ],
    );
  }

  Widget _buildRecommendWidget(List<RecommendResourceRecommend> resource) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 20.w, left: 15.w, right: 15.w),
          child: Text(
            'Recently Played',
            style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(
          height: 320.w,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Wrap(
                direction: Axis.vertical,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ImageView(
                    url: resource[index].picUrl ?? "",
                    width: 210.w,
                    height: 210.w,
                    cornerRadius: 30.r,
                    isCircle: true,
                  ),
                  SizedBox(height: 10.w),
                  SizedBox(
                    width: 200.w,
                    child: Text(
                      resource[index].name ?? '',
                      style: TextStyle(fontSize: 24.sp),
                      maxLines: 2,
                    ),
                  )
                ],
              ),
            ),
            itemCount: resource.length > 10 ? 10 : resource.length,
          ),
        )
      ],
    );
  }
}

class PlayListView extends StatefulWidget {
  const PlayListView({super.key});

  @override
  State<PlayListView> createState() => _PlayListViewState();
}

class _PlayListViewState extends State<PlayListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: 50.w,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(tag: 'images', child: Container(
                  width: 600.w,
                  height: 600.w,
                  child: ImageView(url: 'https://p2.music.126.net/VxlVtJCnBkHmyoY6PbnNOA==/109951169548313443.jpg',width: 400.w,height: 400.w,cornerRadius: 30.r,),
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
