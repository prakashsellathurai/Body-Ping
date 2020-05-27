import 'package:gkfit/bloc/trackers/water_intake/water_intake_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gkfit/bloc/trackers/water_intake/water_intake_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gkfit/screens/dashboard/home/trackers/water_tracker/water_intake_history/waterIntakeHistoryWidget.dart';
import 'package:gkfit/screens/dashboard/ui_view/glass_view.dart';

import '../../../dashboard_theme.dart';
import './mini_water_intake_dashboard.dart';
import 'history/group_chart.dart';
import 'history/history_widget.dart';
import './history/database.dart' as db;
import 'package:charts_flutter/flutter.dart' as charts;
import './history/models/balance.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import './../../../ui_view/title_view.dart';
import 'history/models/domain.dart';
import 'package:gkfit/services/auth_service.dart';


class WaterTrackerHomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WaterTrackerHomeScreenState();
}

class WaterTrackerHomeScreenState extends State<WaterTrackerHomeScreen>
    with TickerProviderStateMixin {
  final Map<String, List<String>> timeValues = {
    "Day": ["Mon", "Tue", "Wed", "Thur", "Fri", "Sat", "Sun"],
    "Month": [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "June",
      "July",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ],
    "Year": List.generate(3, (index) => "20${index + 20}").toList()
  };
  String mainValue = "Day";
  int subIndex = 0;

  WaterIntakeBloc waterIntakebloc;
  User user;

  AnimationController animationController;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    waterIntakebloc = BlocProvider.of<WaterIntakeBloc>(context);
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          elevation: 10,
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back),
              onPressed: () {
                waterIntakebloc..add(UpdateWaterIntakeEvent());
                Navigator.pop(context, true);
              }),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: DashboardTheme.nearlyWhite,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(45),
            bottomRight: Radius.circular(45),
          )),
          centerTitle: true,
          title: Text(
            "Water Tracker",
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: Colors.black),
          ),
        ),
        backgroundColor: DashboardTheme.background,
        body: listView());
  }

  Widget listView() {
    int count = 7;
    List<Widget> listViews = <Widget>[];
    listViews.add(WaterIntakeMiniDashboardView(
      mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
              parent: animationController,
              curve:
                  Interval((1 / count) * 7, 1.0, curve: Curves.fastOutSlowIn))),
      mainScreenAnimationController: animationController,
    ));
    listViews.add(
      GlassView(
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                  parent: animationController,
                  curve: Interval((1 / 9) * 8, 1.0,
                      curve: Curves.fastOutSlowIn))),
          animationController: animationController),
    );

    listViews.add(JustTitleView(
      titleTxt: "Water Intake History",
      animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: animationController,
          curve: Interval((1 / count) * 7, 1.0, curve: Curves.fastOutSlowIn))),
      animationController: animationController,
    ));

    listViews.add(WaterIntakeHistoryWidget());
    return ListView.builder(
        padding: EdgeInsets.only(
          // top: AppBar().preferredSize.height +
          //     MediaQuery.of(context).padding.top +
          //     24,
          bottom: 62 + MediaQuery.of(context).padding.bottom,
        ),
        itemCount: listViews.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          animationController.forward();
          return listViews[index];
        });
  }
}
