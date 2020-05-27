import 'package:gkfit/constants/colors.dart';
import 'package:flutter/material.dart';
import '../../../dashboard_theme.dart';

class AddLogView extends StatelessWidget {
  final AnimationController animationController;
  final Animation animation;
  final void Function() onTap;
  const AddLogView(
      {Key key, this.animationController, this.animation, this.onTap})
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
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 0, bottom: 24),
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
                            child: GestureDetector(
                              onTap: onTap,
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12,
                                        bottom: 12,
                                        right: 12,
                                        top: 12),
                                    child: Text(
                                      'Add your Body Measurement Log here',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: DashboardTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        letterSpacing: 0.0,
                                        color: DashboardTheme.nearlyDarkBlue
                                            .withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                      icon: Icon(Icons.arrow_forward_ios),
                                      onPressed: null),
                                ],
                              ),
                            ),
                          )),

                      // Positioned(
                      //   top: -12,
                      //   left: 0,
                      //   child: SizedBox(
                      //     width: 80,
                      //     height: 80,
                      //     child:
                      //         Image.asset("assets/images/dashboard/glass.png"),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
