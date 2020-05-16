import 'package:cached_network_image/cached_network_image.dart';
import './../loading/shimmer_box.dart';
import 'package:flutter/material.dart';

class PostContainer extends StatelessWidget {
  final onTap;
  final String title, author, image;

  const PostContainer(
      {Key key, this.onTap, this.title, this.author, this.image})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9.0),
      child: ListTile(
        onTap: onTap,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(9.0),
          child: CachedNetworkImage(imageUrl: image,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
           placeholder: (context, url) => ShimmerBox(height: 100,width: 100,)
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "$title",
              style: Theme.of(context).textTheme.subhead,
            ),
            SizedBox(height: 5),
            Text(
              "$author",
              style: Theme.of(context).textTheme.body2,
            ),
          ],
        ),
      ),
    );
  }
}
