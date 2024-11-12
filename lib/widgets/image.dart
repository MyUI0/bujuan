import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;

  final double? marginLeft;
  final double? marginRight;
  final double? marginTop;
  final double? marginBottom;
  final double? cornerRadius;

  final double? margin;
  final double? borderWidth;
  final Color? borderColor;
  final bool? isCircle;
  final Color? backgroundColor;
  final VoidCallback? onClick;

  const ImageView(
      {super.key,
      required this.url,
      this.width,
      this.height,
      this.marginLeft,
      this.marginRight,
      this.marginTop,
      this.marginBottom,
      this.cornerRadius,
      this.margin,
      this.borderWidth,
      this.borderColor,
      this.isCircle,
      this.backgroundColor,
      this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(marginLeft ?? 0, marginTop ?? 0,
            marginRight ?? 0, marginBottom ?? 0),
        decoration: BoxDecoration(
          border: Border.all(
              width: borderWidth ?? 0,
              color: borderColor ?? Colors.transparent),
          color: backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(cornerRadius ?? 0)),
        ),
        child: GestureDetector(
          onTap: onClick,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(cornerRadius ?? 0),
              child: getImage()),
        ));
  }

  Widget getImage() {
    if (url.startsWith("http")) {
      //网络图片
      return CachedNetworkImage(
        imageUrl: '$url${isCircle ?? false ? '?param=${width}y$height' : ''}',
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    } else if (url.startsWith("assets")) {
      //项目内图片
      print("加载项目图片:$url");
      return Image.asset(url, width: width, height: height, fit: BoxFit.cover);
    } else {
      //加载手机里面的图片
      return Image.file(File(url),
          width: width, height: height, fit: BoxFit.cover);
    }
  }
}
