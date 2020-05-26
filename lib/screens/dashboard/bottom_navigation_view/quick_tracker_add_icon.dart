import 'package:gkfit/screens/dashboard/home/trackers/bmi_tracker/bmi_tracker_home.dart';
import 'package:gkfit/screens/dashboard/home/trackers/calorie_tracker/calorie_tracker_home.dart';
import 'package:gkfit/screens/dashboard/home/trackers/water_tracker/water_tracker_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../dashboard_theme.dart';

class QuickTrackerAddIcon extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => QuickTrackerAddIconState();
}

class QuickTrackerAddIconState extends State<QuickTrackerAddIcon>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation degOneTranslationAnimation,
      degTwoTranslationAnimation,
      degThreeTranslationAnimation;
  Animation rotationAnimation;

  Animation mainButtonrotationAnimation;

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    degOneTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.2), weight: 75.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.2, end: 1.0), weight: 25.0),
    ]).animate(animationController);
    degTwoTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.4), weight: 55.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.4, end: 1.0), weight: 45.0),
    ]).animate(animationController);
    degThreeTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.75), weight: 35.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.75, end: 1.0), weight: 65.0),
    ]).animate(animationController);
    rotationAnimation = Tween<double>(begin: 180.0, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut));
    mainButtonrotationAnimation = Tween<double>(begin: 180.0, end: 45.0)
        .animate(CurvedAnimation(
            parent: animationController, curve: Curves.easeOut));
    super.initState();
    animationController.addListener(() {
      setState(() {});
    });
  }

  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
        color: Colors.transparent,
        child: Center(
            child: Container(
                height: 60,
                child: Stack(
                  children: <Widget>[
                    // GestureDetector(
                    //   onTap: () {
                    //     print("onvl");
                    //   },
                    //   child: InkWell(
                    //     child: Transform.translate(
                    //       offset: Offset.fromDirection(
                    //           getRadiansFromDegree(330),
                    //           degOneTranslationAnimation.value * 100),
                    //       child: Transform(
                    //         transform: Matrix4.rotationZ(
                    //             getRadiansFromDegree(rotationAnimation.value))
                    //           ..scale(degOneTranslationAnimation.value),
                    //         alignment: Alignment.center,
                    //         child: CircularButton(
                    //           color: Colors.transparent,
                    //           width: 100,
                    //           height: 100,
                    //           icon: Image.asset(
                    //             'assets/images/dashboard/glass.png',
                    //           ),
                    //           onClick: () {
                    //             Navigator.of(context).push(MaterialPageRoute(
                    //                 builder: (BuildContext context) =>
                    //                     WaterTrackerHomeScreen()));
                    //           },
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Transform.translate(
                    //   offset: Offset.fromDirection(getRadiansFromDegree(275),
                    //       degTwoTranslationAnimation.value * 100),
                    //   child: Transform(
                    //     transform: Matrix4.rotationZ(
                    //         getRadiansFromDegree(rotationAnimation.value))
                    //       ..scale(degTwoTranslationAnimation.value),
                    //     alignment: Alignment.center,
                    //     child: CircularButton(
                    //       color: Colors.transparent,
                    //       width: 100,
                    //       height: 100,
                    //       icon: SvgPicture.asset(
                    //         'assets/svgs/calorie.svg',
                    //         width: 50,
                    //       ),
                    //       onClick: () {
                    //         Navigator.of(context).push(MaterialPageRoute(
                    //             builder: (BuildContext context) =>
                    //                 CalorietrackerHomeScreen()));
                    //       },
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      child:
                    Transform.translate(
                      offset: Offset.fromDirection(getRadiansFromDegree(220),
                          degThreeTranslationAnimation.value * 100),
                      child: Transform(
                        transform: Matrix4.rotationZ(
                            getRadiansFromDegree(rotationAnimation.value))
                          ..scale(degThreeTranslationAnimation.value),
                        alignment: Alignment.center,
                        child: CircularButton(
                          color: Colors.transparent, //Color(0XFF265BC5),
                          width: 100,
                          height: 100,
                          icon: Icon(Icons.ac_unit)
                          
                          // SvgPicture.asset(
                          //   'assets/svgs/weight.svg',
                          //   width: 50,
                          // )
                          ,
                          onClick: () {
                       
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    BmitrackerHomeScreen()));
                          },
                        ),
                      ),
                    ),
                    ),

                    
                    Transform(
                      transform: Matrix4.rotationZ(getRadiansFromDegree(
                          mainButtonrotationAnimation.value)),
                      alignment: Alignment.center,
                      child: CircularCenterButton(
                        color: Colors.indigo,
                        width: 60,
                        height: 60,
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onClick: () {
                          
                          if (animationController.isCompleted) {
                            animationController.reverse();
                          } else {
                            animationController.forward();
                          }
                        },
                      ),
                    )
                  ],
                ))));
  }
}

class CircularCenterButton extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Widget icon;
  final Function onClick;

  CircularCenterButton(
      {this.color, this.width, this.height, this.icon, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      width: width,
      height: height,
      child: IconButton(icon: icon, enableFeedback: true, onPressed: onClick),
    );
  }
}

class CircularButton extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Widget icon;
  final Function onClick;

  CircularButton(
      {this.color, this.width, this.height, this.icon, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [
        BoxShadow(
            color: DashboardTheme.nearlyDarkBlue.withOpacity(0.4),
            offset: const Offset(8.0, 12.0),
            blurRadius: 12.0),
      ]),
      width: width,
      height: height,
      child: IconButton(icon: icon, enableFeedback: true, onPressed: onClick),
    );
  }
}
