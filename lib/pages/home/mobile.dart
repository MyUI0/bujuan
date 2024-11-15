import 'package:bujuan/common/request_state.dart';
import 'package:bujuan/common/values/icons.dart';
import 'package:bujuan/pages/home/provider.dart';
import 'package:bujuan/widgets/album.dart';
import 'package:bujuan/widgets/image.dart';
import 'package:bujuan_music_api/api/recommend/entity/recommend_resource_entity.dart';
import 'package:bujuan_music_api/api/top/entity/top_artist_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class HomeMobile extends ConsumerStatefulWidget {
  const HomeMobile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomeMobile> with SingleTickerProviderStateMixin {
  late HomeRequestNotifier controller;
  late AnimationController animationController;

  @override
  void initState() {
    controller = ref.read(homeProvider.notifier);
    animationController = AnimationController(vsync: this);
    animationController.addListener(() {
      print('object=====================================${animationController.value}');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: Icon(Icons.menu),
        actions: [
          IconButton(
              onPressed: () {}, icon: ImageView(url: AppIcons.message, width: 50.w, height: 50.w)),
          IconButton(
            onPressed: () {},
            icon: ImageView(
                url: "https://p2.music.126.net/VxlVtJCnBkHmyoY6PbnNOA==/109951169548313443.jpg",
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
      body: AlbumImage(),
    );
  }
}
