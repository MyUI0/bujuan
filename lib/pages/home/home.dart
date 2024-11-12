import 'package:bujuan/pages/home/provider.dart';
import 'package:bujuan_music_api/bujuan_music_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late HomeRequestNotifier controller;

  @override
  void initState() {
    controller = ref.read(homeProvider.notifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: TextButton(
          onPressed: () async {
            // await BujuanMusicManager().sendSmsCode(phone: '13223087330');
            // BujuanMusicManager().loginCellPhone(phone: '13223087330', captcha: '4655');
            BujuanMusicManager().topArtist();
          },
          child: Text('data')),
    );
  }
}
