import 'package:cached_network_image/cached_network_image.dart';
import './../loading/shimmer_box.dart';
import 'package:flutter/material.dart';

class OverlayedContainer extends StatelessWidget {
  final String title, image, author, authorAvatar;
  final onTap;

  const OverlayedContainer(
      {Key key,
      this.title,
      this.image,
      this.author,
      this.onTap,
      this.authorAvatar})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: CachedNetworkImage(
          imageUrl: image,
          placeholder: (context, url) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 9.0),
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
              ),
              child: ShimmerBox(width: 130, height: 150)),
          errorWidget: (context, url, error) => Icon(Icons.error),
          imageBuilder: (context, imageProvider) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 9.0),
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              image: DecorationImage(
                image: imageProvider,
                colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "$title",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle
                      .copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ));
  }
}
