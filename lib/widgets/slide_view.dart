import 'package:flutter/material.dart';

class SlideView extends StatefulWidget {
  const SlideView({super.key});

  @override
  State<SlideView> createState() => _SlideViewState();
}

class _SlideViewState extends State<SlideView> with SingleTickerProviderStateMixin{
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(vsync: this)..addListener((){

    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

        ],
      ),
    );
  }
}
