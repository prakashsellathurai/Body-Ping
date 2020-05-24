import 'package:gkfit/bloc/trackers/water_intake/water_intake_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gkfit/bloc/trackers/water_intake/water_intake_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
import 'package:gkfit/widgets/charts/time_series_chart_with_bar_renderer.dart';

import 'package:gkfit/bloc/trackers/water_intake/water_intake_repository.dart';

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
  List<charts.Series<Balance, String>> series;
  WaterIntakeBloc waterIntakebloc;
  User user;
  WaterIntakeRepository _waterIntakeRepository = WaterIntakeRepository();
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

  // updateData() async {
  //   Timer(Duration(milliseconds: 400), () {
  //     setState(() {
  //       series = db.getSeries(mainValue, subIndex, max: 1000);
  //     });
  //   });
  // }

  Widget listView() {
    int count = 7;
    List<Widget> listViews = <Widget>[];
    listViews.add(WaterIntakeMiniDashboardView(
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: animationController,
                curve: Interval((1 / count) * 7, 1.0,
                    curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: animationController,
        daily_target: 3500,
        current_water_intake: 2100));
    // listViews.add(
    //   DropWidget(
    //     timeValues,
    //     (mainValue, subIndex) {
    //       setState(() {
    //         if (this.mainValue != mainValue) this.mainValue = mainValue;
    //         if (this.subIndex != subIndex) this.subIndex = subIndex;
    //         series = db.getSeries(mainValue, subIndex, max: 1000);
    //       });
    //     },
    //     mainValue: mainValue,
    //   ),
    // );
    // listViews.add(
    //   Padding(
    //     padding: const EdgeInsets.all(16.0),
    //     child: GroupedBarChart(
    //         Domain.getDomain(["Water Intake"], [Color(0xff1274ED)]), series),
    //   ),
    // );
    listViews.add(JustTitleView(
      titleTxt: "Water Intake History",
      animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: animationController,
          curve: Interval((1 / count) * 7, 1.0, curve: Curves.fastOutSlowIn))),
      animationController: animationController,
    ));
    // List<charts.Series<TimeSeriesSales, DateTime>> waterIntakeData =
    //     _createWaterIntakeChart();
    listViews.add(Container(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<charts.Series<TimeSeriesSales, DateTime>>>(
            future: _createWaterIntakeChart(),
            builder: (BuildContext context,
                AsyncSnapshot<List<charts.Series<TimeSeriesSales, DateTime>>>
                    snapshot) {
                      print(snapshot.data);
              if (snapshot.hasData) {
                print(snapshot.data);
                return new TimeSeriesBar(
                  snapshot.data,
                  animate: true,
                  
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        )));
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

  Future<List<charts.Series<TimeSeriesSales, DateTime>>>
      _createWaterIntakeChart() async {
    AutogeneratedWaterIntake autogen =
        await _waterIntakeRepository.fetchWaterIntakeHistory(user.uid);
    List<TimeSeriesSales> data = [];
    autogen.results.forEach((element) {
  print(new DateTime(2017, 9, 1));
  print( DateTime.parse(element.day));
      data.add(new TimeSeriesSales(
              DateTime.parse(element.day),
          int.parse(element.quantity_in_ml).toInt()));
    });

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) =>new DateTime(sales.time.year,sales.time.month,sales.time.day),
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}
