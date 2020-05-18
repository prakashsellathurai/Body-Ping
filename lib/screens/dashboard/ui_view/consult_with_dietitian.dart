import './../../../constants/colors.dart';
import 'package:flutter/material.dart';
import '../dashboard_theme.dart';

class ConsultWithOurDieticianView extends StatelessWidget {
  final AnimationController animationController;
  final Animation animation;

  final void Function() onTap;

  const ConsultWithOurDieticianView({Key key, this.animationController, this.animation,this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    DashboardTheme.nearlyDarkBlue,
                    HexColor("#6F56E8")
                  ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(68.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: DashboardTheme.grey.withOpacity(0.6),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Text(
                      //   'Next workout',
                      //   textAlign: TextAlign.left,
                      //   style: TextStyle(
                      //     fontFamily: DashboardTheme.fontName,
                      //     fontWeight: FontWeight.normal,
                      //     fontSize: 14,
                      //     letterSpacing: 0.0,
                      //     color: DashboardTheme.white,
                      //   ),
                      // ),
                             Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Column(
                                children: <Widget>[
                                Icon(
                                Icons.fitness_center,
                                color: DashboardTheme.white,
                                size: 16,
                              ),
                                ]
                              )
                            ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Consult With \nour Experts here',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: DashboardTheme.fontName,
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                            letterSpacing: 0.0,
                            color: DashboardTheme.white,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 32,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Icon(
                                Icons.timer,
                                color: DashboardTheme.white,
                                size: 16,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text(
                                'All it takes is just a single click',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: DashboardTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  letterSpacing: 0.0,
                                  color: DashboardTheme.white,
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            GestureDetector(
                              onTap: onTap,
                              child: 
                            Container(
                              decoration: BoxDecoration(
                                color: DashboardTheme.nearlyWhite,
                                shape: BoxShape.circle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: DashboardTheme.nearlyBlack
                                          .withOpacity(0.4),
                                      offset: Offset(8.0, 8.0),
                                      blurRadius: 8.0),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Icon(
                                  Icons.arrow_right,
                                  color: HexColor("#6F56E8"),
                                  size: 44,
                                ),
                              ),
                            )
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
