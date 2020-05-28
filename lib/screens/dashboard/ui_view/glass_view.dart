import './../../../constants/colors.dart';
import 'package:flutter/material.dart';

import '../dashboard_theme.dart';

class GlassView extends StatelessWidget {
  const GlassView({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 24),
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: HexColor("#D7E0F9"),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                        topRight: Radius.circular(8.0)),
                  ),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 68, bottom: 12, right: 16, top: 12),
                        child: Text(
                          'Prepare your stomach for ${mealNameGenerator()} with one or two glass of water',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: DashboardTheme.fontName,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            letterSpacing: 0.0,
                            color:
                                DashboardTheme.nearlyDarkBlue.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: -12,
                left: 0,
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: Image.asset("assets/images/dashboard/glass.png"),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  String mealNameGenerator() {
    var hour = DateTime.now().toLocal().hour;
    if (hour < 12) {
      return 'breakfast';
    }
    if (hour < 17) {
      return 'lunch';
    }
    return 'dinner';
  }
}
