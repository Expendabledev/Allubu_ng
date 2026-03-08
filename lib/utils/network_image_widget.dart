import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yelpify/constant/constant.dart';

class NetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final Widget? errorWidget;
  final BoxFit? fit;
  final double? borderRadius;
  final Color? color;

  const NetworkImageWidget({
    super.key,
    this.height,
    this.width,
    this.fit,
    required this.imageUrl,
    this.borderRadius,
    this.errorWidget,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit ?? BoxFit.fitWidth,
      height: height,
      width: width ,
      color: color,
      progressIndicatorBuilder: (context, url, downloadProgress) => Image.asset(
        "assets/images/simmer_gif.gif",
        height: height,
        width: width,
        fit: BoxFit.fill,
      ),
      errorWidget: (context, url, error) =>
          errorWidget ??
          SvgPicture.asset(
            Constant.userPlaceHolder,
            fit: fit ?? BoxFit.fitWidth,
            height: height,
            width: width,
          ),
    );
  }
}
