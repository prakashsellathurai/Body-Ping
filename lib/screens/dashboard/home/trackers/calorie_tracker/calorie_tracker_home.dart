import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../ui_view/mediterranesn_diet_view.dart';
import '../../../dashboard_theme.dart';
import './../../../home/meals_list_view.dart';
import './../../../ui_view/title_view.dart';
import './your_nutrition_report_screen.dart';

class CalorietrackerHomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CalorietrackerHomeScreenState();
}

class CalorietrackerHomeScreenState extends State<CalorietrackerHomeScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
  }

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
          centerTitle: true,
          title: Text(
            "Calorie Intake Tracker",
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
    int count = 9;
    List<Widget> listViews = <Widget>[];
    listViews.add(
      MediterranesnDietView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController,
            curve:
                Interval((1 / count) * 1, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: animationController,
      ),
    );
    listViews.add(
      TitleView(
        titleTxt: 'Your Nutrition Report',
        subTxt: 'Details',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController,
            curve:
                Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: animationController,
        onclick: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => YourNutritionReportScreen()));
        },
      ),
    );
    listViews.add(MealsListView(
      mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
              parent: animationController,
              curve:
                  Interval((1 / count) * 1, 1.0, curve: Curves.fastOutSlowIn))),
      mainScreenAnimationController: animationController,
    ));

    listViews.add(Padding(
        padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
        child: Text(
          '*tap the corresponding box to add your meal',
          style: TextStyle(
            fontFamily: DashboardTheme.fontName,
            fontSize: 8,
            letterSpacing: 0.2,
          ),
        )));
    return ListView.builder(
      // controller: scrollController,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        bottom: 62 + MediaQuery.of(context).padding.bottom,
      ),
      itemCount: listViews.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        animationController.forward();
        return listViews[index];
      },
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
