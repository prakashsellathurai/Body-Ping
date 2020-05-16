import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBox extends StatelessWidget {
  double height,width;

  ShimmerBox({this.width,this.height});

  @override
  Widget build(BuildContext context) {
    // TODO: implement createState
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(
          8
        ),
        child: Shimmer.fromColors(
            baseColor: Colors.grey[400],
            highlightColor: Colors.grey[100],
            enabled: true,
            child: Container(
              width: width,
              height:height ,
              color: Colors.white,
            )),
      ),
    );
  }
}
