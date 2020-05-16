import 'package:flutter/cupertino.dart';
import 'package:pk_skeleton/pk_skeleton.dart';

class BlogLisLoader extends StatelessWidget {
  final int length;

  const BlogLisLoader({Key key, this.length}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
        children: List<Widget>.generate(
            length,
            (int index) => PKCardSkeleton(
                  isCircularImage: false,
                  isBottomLinesActive: true,
                ))

      
        );
  }
}
