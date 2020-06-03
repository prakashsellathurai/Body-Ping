import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gkfit/screens/dashboard/dashboard_screen.dart';
import 'package:gkfit/screens/dashboard/home/trackers/bmi_tracker/logViewWidget.dart';
import 'package:gkfit/services/auth_service.dart';
import 'package:provider/provider.dart';
import '../../../ui_view/title_view.dart';
import '../../../dashboard_theme.dart';
import '../../../ui_view/body_measurement.dart';
import 'add_bmi/input_page.dart';
import 'bmi_history/bmi_history.dart';

class BmitrackerHomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BmitrackerHomeScreenState();
}

class BmitrackerHomeScreenState extends State<BmitrackerHomeScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;
  @override
  Widget build(BuildContext context) {
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
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AppDashboardHomeScreen(
                          user: Provider.of<User>(context),
                        )),
              );
            },
          ),
          centerTitle: true,
          title: Text(
            "Weight Tracker",
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: Colors.black),
          ),
        ),
        backgroundColor: DashboardTheme.background,
        body: listView());
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    super.initState();
  }

  Widget listView() {
    int count = 7;
    List<Widget> listViews = <Widget>[];
    listViews.add(
      BodyMeasurementView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController,
            curve:
                Interval((1 / count) * 5, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: animationController,
      ),
    );
    listViews.add(
      AddLogView(
          animation: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                  parent: animationController,
                  curve: Interval((1 / count) * 5, 1.0,
                      curve: Curves.fastOutSlowIn))),
          animationController: animationController,
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => InputPage()));
          }),
    );
    listViews.add(
      JustTitleView(
        titleTxt: 'Weight Chart',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController,
            curve:
                Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: animationController,
        onclick: () {},
      ),
    );
    listViews.add(BmIHistoryWidget());
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
