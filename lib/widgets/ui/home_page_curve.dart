import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import './../../constants/colors.dart';

class BezierContainer extends StatelessWidget {
  const BezierContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
          painter: CurvePainter(),
        child: Container(
          height: MediaQuery.of(context).size.height /4 ,
          width: MediaQuery.of(context).size.width ,
          // decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       begin: Alignment.topCenter,
          //       end: Alignment.bottomCenter,
          //       colors: [base_color,complementary_color]
          //     )
           // ),
        ),
    );
  }
}
class CurvePainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
  Path path = Path();
  Paint paint = Paint();


  path.lineTo(0, size.height *0.75);
  path.quadraticBezierTo(size.width* 0.10, size.height*0.70,   size.width*0.17, size.height*0.90);
  path.quadraticBezierTo(size.width*0.20, size.height, size.width*0.25, size.height*0.90);
  path.quadraticBezierTo(size.width*0.40, size.height*0.40, size.width*0.50, size.height*0.70);
  path.quadraticBezierTo(size.width*0.60, size.height*0.85, size.width*0.65, size.height*0.65);
  path.quadraticBezierTo(size.width*0.70, size.height*0.90, size.width, 0);
  path.close();

  paint.color = base_color;
  canvas.drawPath(path, paint);

  path = Path();
  path.lineTo(0, size.height*0.50);
  path.quadraticBezierTo(size.width*0.10, size.height*0.80, size.width*0.15, size.height*0.60);
  path.quadraticBezierTo(size.width*0.20, size.height*0.45, size.width*0.27, size.height*0.60);
  path.quadraticBezierTo(size.width*0.45, size.height, size.width*0.50, size.height*0.80);
  path.quadraticBezierTo(size.width*0.55, size.height*0.45, size.width*0.75, size.height*0.75);
  path.quadraticBezierTo(size.width*0.85, size.height*0.93, size.width, size.height*0.60);
  path.lineTo(size.width, 0);
  path.close();

  paint.color = secondary_color;
  canvas.drawPath(path, paint);

  path =Path();
  path.lineTo(0, size.height*0.75);
  path.quadraticBezierTo(size.width*0.10, size.height*0.55, size.width*0.22, size.height*0.70);
  path.quadraticBezierTo(size.width*0.30, size.height*0.90, size.width*0.40, size.height*0.75);
  path.quadraticBezierTo(size.width*0.52, size.height*0.50, size.width*0.65, size.height*0.70);
  path.quadraticBezierTo(size.width*0.75, size.height*0.85, size.width, size.height*0.60);
  path.lineTo(size.width, 0);
  path.close();

  paint.color = tertiary_color;
  canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }

}


