import '../card_title.dart';
import '../utils/widget_utils.dart' show screenAwareSize;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'bodyfatSlider.dart';

class BodyFat extends StatelessWidget {
  final int bodyfat;
  final ValueChanged<int> onChanged;

  const BodyFat({Key key, this.bodyfat = 20, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(
        left: screenAwareSize(16.0, context),
        right: screenAwareSize(4.0, context),
        top: screenAwareSize(4.0, context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CardTitle("BODY FAT", subtitle: "(%)"),
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenAwareSize(16.0, context)),
                child: _drawSlider(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawSlider() {
    return bodyfatBackground(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.isTight
              ? Container()
              : BodyFatSlider(
                  minValue: 1,
                  maxValue: 90,
                  value: bodyfat,
                  onChanged: (val) => onChanged(val),
                  width: constraints.maxWidth,
                );
        },
      ),
    );
  }
}

class bodyfatBackground extends StatelessWidget {
  final Widget child;

  const bodyfatBackground({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          height: screenAwareSize(100.0, context),
          decoration: BoxDecoration(
            color: Color.fromRGBO(244, 244, 244, 1.0),
            borderRadius:
                new BorderRadius.circular(screenAwareSize(50.0, context)),
          ),
          child: child,
        ),
        SvgPicture.asset(
          "assets/images/bmi/weight_arrow.svg",
          height: screenAwareSize(10.0, context),
          width: screenAwareSize(18.0, context),
        ),
      ],
    );
  }
}
