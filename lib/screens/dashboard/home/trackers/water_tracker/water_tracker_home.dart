import 'package:gkfit/bloc/trackers/water_intake/water_intake_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gkfit/bloc/trackers/water_intake/water_intake_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../dashboard_theme.dart';
import './mini_water_intake_dashboard.dart';
import 'history/group_chart.dart';
import 'history/history_widget.dart';
import './history/database.dart' as db;
import 'package:charts_flutter/flutter.dart' as charts;
import './history/models/balance.dart';

import 'dart:async';

import 'history/models/domain.dart';
class WaterTrackerHomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => WaterTrackerHomeScreenState();
}

class WaterTrackerHomeScreenState extends State<WaterTrackerHomeScreen>
    with TickerProviderStateMixin {

        final Map<String,List<String>>timeValues={
    "Day":["Mon","Tue","Wed","Thur","Fri","Sat","Sun"],
    "Month":["Jan","Feb","Mar","Apr","May","June","July","Sep","Oct","Nov","Dec"],
    "Year":List.generate(3, (index)=>"20${index+20}").toList()
  };
  String mainValue="Day";
  int subIndex=0;
  List<charts.Series<Balance, String>>series;
  WaterIntakeBloc waterIntakebloc;

  AnimationController animationController;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    // TODO: implement initState
     series=db.getSeries(mainValue, subIndex,max:10);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    waterIntakebloc = BlocProvider.of<WaterIntakeBloc>(context);
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          elevation: 10,
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
    updateData()async{
    Timer(Duration(milliseconds: 400),(){
      setState(() {
        series=db.getSeries(mainValue, subIndex,max:1000);
      });
    });
  }

  Widget listView() {
    int count = 9;
    List<Widget> listViews = <Widget>[];
    listViews.add(WaterIntakeMiniDashboardView(
      mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
              parent: animationController,
              curve:
                  Interval((1 / count) * 7, 1.0, curve: Curves.fastOutSlowIn))),
      mainScreenAnimationController: animationController,
      daily_target: 3500,
      current_water_intake: 2100,
      last_drink_time: DateTime.now().toIso8601String()
    ));
    listViews.add(
         DropWidget(timeValues,(mainValue,subIndex){
            setState(() {
              if(this.mainValue!=mainValue)
                this.mainValue=mainValue;
              if(this.subIndex!=subIndex)
                this.subIndex=subIndex;
              series=db.getSeries(mainValue, subIndex,max:1000);
            });
          },mainValue: mainValue,),
    );
    listViews.add(
           Padding(
            padding: const EdgeInsets.all(16.0),
            child: GroupedBarChart(Domain.getDomain(["Water Intake"], [Color(0xff1274ED)]),series),
          ),
    );
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
