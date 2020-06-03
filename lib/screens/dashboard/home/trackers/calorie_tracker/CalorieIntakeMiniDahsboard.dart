import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gkfit/bloc/trackers/calorieIntake/CalorieIntakeBloc.dart';
import 'package:gkfit/bloc/trackers/calorieIntake/CalorieIntakeEvent.dart';

import 'package:gkfit/model/DailyRequiremnentModel.dart';
import 'package:gkfit/screens/dashboard/home/trackers/calorie_tracker/calorie_tracker_home.dart';
import '../../../dashboard_theme.dart';
import './../../../../../constants/colors.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class CalorieIntakeMiniDashBoard extends StatelessWidget {
  final AnimationController animationController;
  final Animation animation;
  final bool noInteraction;

  const CalorieIntakeMiniDashBoard(
      {Key key, this.animationController, this.animation, this.noInteraction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    CalorieIntakeBloc calorieIntakeBloc =
        BlocProvider.of<CalorieIntakeBloc>(context);
    // calorieIntakeBloc..add(FetchEntiredayMealModelEvent());
    DailyRequirements dailyRequirements = DailyRequirements();
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
                child: GestureDetector(
                  onTap: () {
                    if (!noInteraction) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              CalorietrackerHomeScreen()));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: DashboardTheme.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          bottomLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0),
                          topRight: Radius.circular(68.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: DashboardTheme.grey.withOpacity(0.2),
                            offset: Offset(1.1, 1.1),
                            blurRadius: 10.0),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, left: 16, right: 16),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8, right: 8, top: 4),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            height: 48,
                                            width: 2,
                                            decoration: BoxDecoration(
                                              color: HexColor('#87A0E5')
                                                  .withOpacity(0.5),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4.0)),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4, bottom: 2),
                                                  child: Text(
                                                    'Eaten',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: DashboardTheme
                                                          .fontName,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16,
                                                      letterSpacing: -0.1,
                                                      color: DashboardTheme.grey
                                                          .withOpacity(0.5),
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      width: 28,
                                                      height: 28,
                                                      child: Image.asset(
                                                          "assets/images/dashboard/eaten.png"),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 4,
                                                              bottom: 3),
                                                      child: Text(
                                                        (calorieIntakeBloc.state
                                                                    .totalEatenInKcal
                                                                    .toInt() >
                                                                1000)
                                                            ? '${(calorieIntakeBloc.state.totalEatenInKcal * animation.value).toInt() / 1000}'
                                                            : '${(calorieIntakeBloc.state.totalEatenInKcal * animation.value).toInt()}',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              DashboardTheme
                                                                  .fontName,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16,
                                                          color: DashboardTheme
                                                              .darkerText,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 4,
                                                              bottom: 3),
                                                      child: Text(
                                                        (calorieIntakeBloc.state
                                                                    .totalEatenInKcal
                                                                    .toInt() >
                                                                1000)
                                                            ? 'Kcal'
                                                            : 'cal',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              DashboardTheme
                                                                  .fontName,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 12,
                                                          letterSpacing: -0.2,
                                                          color: DashboardTheme
                                                              .grey
                                                              .withOpacity(0.5),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(children: <Widget>[
                                        Container(
                                          height: 48,
                                          width: 2,
                                          decoration: BoxDecoration(
                                            color: HexColor('#F56E98')
                                                .withOpacity(0.5),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4.0)),
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    'Protein',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: DashboardTheme
                                                          .fontName,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16,
                                                      letterSpacing: -0.2,
                                                      color: DashboardTheme
                                                          .darkText,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 4),
                                                    child: Container(
                                                      height: 4,
                                                      width: 70,
                                                      decoration: BoxDecoration(
                                                        color: HexColor(
                                                                '#F56E98')
                                                            .withOpacity(0.2),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    4.0)),
                                                      ),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Container(
                                                            width: (70 *
                                                                ((calorieIntakeBloc.state.totalproteins <
                                                                            dailyRequirements
                                                                                .proteins)
                                                                        ? (calorieIntakeBloc.state.totalproteins /
                                                                            dailyRequirements
                                                                                .proteins)
                                                                        : 1)
                                                                    .toDouble() *
                                                                animationController
                                                                    .value),
                                                            height: 4,
                                                            decoration:
                                                                BoxDecoration(
                                                              gradient:
                                                                  LinearGradient(
                                                                      colors: [
                                                                    HexColor(
                                                                            '#F56E98')
                                                                        .withOpacity(
                                                                            0.1),
                                                                    HexColor(
                                                                        '#F56E98'),
                                                                  ]),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          4.0)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 6),
                                                    child: Text(
                                                      (dailyRequirements
                                                                  .proteins
                                                                  .toInt() >
                                                              calorieIntakeBloc
                                                                  .state
                                                                  .totalproteins
                                                                  .toInt())
                                                          ? '${(((dailyRequirements.proteins - calorieIntakeBloc.state.totalproteins)).toInt())}g left'
                                                          : '${(((calorieIntakeBloc.state.totalproteins - dailyRequirements.proteins)).toInt())}g more',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            DashboardTheme
                                                                .fontName,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12,
                                                        color: DashboardTheme
                                                            .grey
                                                            .withOpacity(0.5),
                                                      ),
                                                    ),
                                                  ),
                                                ]))
                                      ])
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: Center(
                                  child: Stack(
                                    overflow: Overflow.visible,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: DashboardTheme.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(100.0),
                                            ),
                                            border: new Border.all(
                                                width: 4,
                                                color: DashboardTheme
                                                    .nearlyDarkBlue
                                                    .withOpacity(0.2)),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                (dailyRequirements.totalEnergy >
                                                        (calorieIntakeBloc
                                                                    .state.totalEatenInKcal >
                                                                1000
                                                            ? calorieIntakeBloc
                                                                    .state
                                                                    .totalEatenInKcal /
                                                                1000
                                                            : calorieIntakeBloc
                                                                .state
                                                                .totalEatenInKcal))
                                                    ? '${((dailyRequirements.totalEnergy - (calorieIntakeBloc.state.totalEatenInKcal > 1000 ? calorieIntakeBloc.state.totalEatenInKcal / 1000 : calorieIntakeBloc.state.totalEatenInKcal)) * animation.value).toInt()}'
                                                    : '${((((calorieIntakeBloc.state.totalEatenInKcal > 1000 ? calorieIntakeBloc.state.totalEatenInKcal / 1000 : calorieIntakeBloc.state.totalEatenInKcal) - dailyRequirements.totalEnergy)) * animation.value).toInt()}',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily:
                                                      DashboardTheme.fontName,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 24,
                                                  letterSpacing: 0.0,
                                                  color: DashboardTheme
                                                      .nearlyDarkBlue,
                                                ),
                                              ),
                                              Text(
                                                (dailyRequirements.totalEnergy >
                                                        calorieIntakeBloc.state
                                                            .totalEatenInKcal)
                                                    ? 'Kcal left'
                                                    : 'Kcal more ',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily:
                                                      DashboardTheme.fontName,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: (dailyRequirements
                                                              .totalEnergy >
                                                          calorieIntakeBloc
                                                              .state
                                                              .totalEatenInKcal)
                                                      ? 12
                                                      : 9,
                                                  letterSpacing: 0.0,
                                                  color: DashboardTheme.grey
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: CustomPaint(
                                          painter: CurvePainter(
                                              colors:
                                                  ((calorieIntakeBloc.state.totalEatenInKcal / 1000) /
                                                              dailyRequirements
                                                                  .totalEnergy > 0.99)
                                                      ? [
                                                          Colors.red,
                                                          HexColor("##FF0000"),
                                                          HexColor("##FF0000")
                                                        ]
                                                      : [
                                                          DashboardTheme
                                                              .nearlyDarkBlue,
                                                          HexColor("#8A98E8"),
                                                          HexColor("#8A98E8")
                                                        ],
                                              angle: (((calorieIntakeBloc.state.totalEatenInKcal > 1000
                                                              ? calorieIntakeBloc
                                                                      .state
                                                                      .totalEatenInKcal /
                                                                  1000
                                                              : calorieIntakeBloc
                                                                  .state
                                                                  .totalEatenInKcal) /
                                                          dailyRequirements
                                                              .totalEnergy) *
                                                      360) +
                                                  (360 -
                                                          (((calorieIntakeBloc.state.totalEatenInKcal > 1000
                                                                      ? calorieIntakeBloc.state.totalEatenInKcal / 1000
                                                                      : calorieIntakeBloc.state.totalEatenInKcal) /
                                                                  dailyRequirements.totalEnergy) *
                                                              360)) *
                                                      (1.0 - animation.value)),
                                          child: SizedBox(
                                            width: 108,
                                            height: 108,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, top: 8, bottom: 8),
                          child: Container(
                            height: 2,
                            decoration: BoxDecoration(
                              color: DashboardTheme.background,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.0)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, top: 8, bottom: 16),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4, bottom: 2),
                                          child: Text(
                                            'Carbs',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily:
                                                  DashboardTheme.fontName,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              letterSpacing: -0.1,
                                              color: DashboardTheme.darkText,
                                            ),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 4),
                                              child: Container(
                                                height: 4,
                                                width: 70,
                                                decoration: BoxDecoration(
                                                  color: HexColor('#87A0E5')
                                                      .withOpacity(0.2),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4.0)),
                                                ),
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width: (70 *
                                                          ((calorieIntakeBloc
                                                                          .state
                                                                          .totalCarbs <
                                                                      dailyRequirements
                                                                          .carbs)
                                                                  ? (calorieIntakeBloc
                                                                          .state
                                                                          .totalCarbs /
                                                                      dailyRequirements
                                                                          .carbs)
                                                                  : 1)
                                                              .toDouble()),
                                                      height: 4,
                                                      decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                                colors: [
                                                              HexColor(
                                                                  '#87A0E5'),
                                                              HexColor(
                                                                      '#87A0E5')
                                                                  .withOpacity(
                                                                      0.5),
                                                            ]),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    4.0)),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 6),
                                              child: Text(
                                                (dailyRequirements.carbs
                                                            .toInt() >
                                                        calorieIntakeBloc
                                                            .state.totalCarbs
                                                            .toInt())
                                                    ? '${(((dailyRequirements.carbs - calorieIntakeBloc.state.totalCarbs)).toInt())}g left'
                                                    : '${(((calorieIntakeBloc.state.totalCarbs - dailyRequirements.carbs)).toInt())}g more',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily:
                                                      DashboardTheme.fontName,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color: DashboardTheme.grey
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Fat',
                                          style: TextStyle(
                                            fontFamily: DashboardTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            letterSpacing: -0.2,
                                            color: DashboardTheme.darkText,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 0, top: 4),
                                          child: Container(
                                            height: 4,
                                            width: 70,
                                            decoration: BoxDecoration(
                                              color: HexColor('#F1B440')
                                                  .withOpacity(0.2),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4.0)),
                                            ),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  width: (70 *
                                                      ((calorieIntakeBloc.state
                                                                      .totalfat <
                                                                  dailyRequirements
                                                                      .fat)
                                                              ? (calorieIntakeBloc
                                                                      .state
                                                                      .totalfat /
                                                                  dailyRequirements
                                                                      .fat)
                                                              : 1)
                                                          .toDouble() *
                                                      animationController
                                                          .value),
                                                  height: 4,
                                                  decoration: BoxDecoration(
                                                    gradient:
                                                        LinearGradient(colors: [
                                                      HexColor('#F1B440')
                                                          .withOpacity(0.1),
                                                      HexColor('#F1B440'),
                                                    ]),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                4.0)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 6),
                                          child: Text(
                                            (dailyRequirements.fat.toInt() >
                                                    calorieIntakeBloc
                                                        .state.totalfat
                                                        .toInt())
                                                ? '${(((dailyRequirements.fat - calorieIntakeBloc.state.totalfat)).toInt())}g left'
                                                : '${(((calorieIntakeBloc.state.totalfat - dailyRequirements.fat)).toInt())}g more',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily:
                                                  DashboardTheme.fontName,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                              color: DashboardTheme.grey
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Fibres',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: DashboardTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            letterSpacing: -0.2,
                                            color: DashboardTheme.darkText,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Container(
                                            height: 4,
                                            width: 70,
                                            decoration: BoxDecoration(
                                              color: HexColor('#F56E98')
                                                  .withOpacity(0.2),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4.0)),
                                            ),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  width: (70 *
                                                      ((calorieIntakeBloc.state
                                                                      .totalfibres <
                                                                  dailyRequirements
                                                                      .fibres)
                                                              ? (calorieIntakeBloc
                                                                      .state
                                                                      .totalfibres /
                                                                  dailyRequirements
                                                                      .fibres)
                                                              : 1)
                                                          .toDouble() *
                                                      animationController
                                                          .value),
                                                  height: 4,
                                                  decoration: BoxDecoration(
                                                    gradient:
                                                        LinearGradient(colors: [
                                                      HexColor('#F56E98')
                                                          .withOpacity(0.1),
                                                      HexColor('#F56E98'),
                                                    ]),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                4.0)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 6),
                                          child: Text(
                                            (dailyRequirements.fibres.toInt() >
                                                    calorieIntakeBloc
                                                        .state.totalfibres
                                                        .toInt())
                                                ? '${(((dailyRequirements.fibres - calorieIntakeBloc.state.totalfibres)).toInt())}g left'
                                                : '${(((calorieIntakeBloc.state.totalfibres - dailyRequirements.fibres)).toInt())}g more',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily:
                                                  DashboardTheme.fontName,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                              color: DashboardTheme.grey
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )),
          ),
        );
      },
    );
  }
}

class CurvePainter extends CustomPainter {
  final double angle;
  final List<Color> colors;

  CurvePainter({this.colors, this.angle = 140});

  @override
  void paint(Canvas canvas, Size size) {
    List<Color> colorsList = List<Color>();
    if (colors != null) {
      colorsList = colors;
    } else {
      colorsList.addAll([Colors.white, Colors.white]);
    }

    final shdowPaint = new Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final shdowPaintCenter = new Offset(size.width / 2, size.height / 2);
    final shdowPaintRadius =
        math.min(size.width / 2, size.height / 2) - (14 / 2);
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.3);
    shdowPaint.strokeWidth = 16;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.2);
    shdowPaint.strokeWidth = 20;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.1);
    shdowPaint.strokeWidth = 22;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    final rect = new Rect.fromLTWH(0.0, 0.0, size.width, size.width);
    final gradient = new SweepGradient(
      startAngle: degreeToRadians(268),
      endAngle: degreeToRadians(270.0 + 360),
      tileMode: TileMode.repeated,
      colors: colorsList,
    );
    final paint = new Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final center = new Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (14 / 2);

    canvas.drawArc(
        new Rect.fromCircle(center: center, radius: radius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        paint);

    final gradient1 = new SweepGradient(
      tileMode: TileMode.repeated,
      colors: [Colors.white, Colors.white],
    );

    var cPaint = new Paint();
    cPaint..shader = gradient1.createShader(rect);
    cPaint..color = Colors.white;
    cPaint..strokeWidth = 14 / 2;
    canvas.save();

    final centerToCircle = size.width / 2;
    canvas.save();

    canvas.translate(centerToCircle, centerToCircle);
    canvas.rotate(degreeToRadians(angle + 2));

    canvas.save();
    canvas.translate(0.0, -centerToCircle + 14 / 2);
    canvas.drawCircle(new Offset(0, 0), 14 / 5, cPaint);

    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double degreeToRadians(double degree) {
    var redian = (math.pi / 180) * degree;
    return redian;
  }
}
