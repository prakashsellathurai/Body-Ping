import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../ui_view/mediterranesn_diet_view.dart';
import 'package:gkfit/services/auth_service.dart';
import 'package:provider/provider.dart';
import '../../../dashboard_theme.dart';
import './../../../home/meals_list_view.dart';
import './../../../ui_view/title_view.dart';
import './your_nutrition_report_screen.dart';
import 'CalorieIntakeMiniDahsboard.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gkfit/bloc/trackers/calorieIntake/CalorieIntakeBloc.dart';
import 'package:gkfit/bloc/trackers/calorieIntake/CalorieIntakeState.dart';
import 'package:gkfit/bloc/trackers/calorieIntake/CalorieIntakeEvent.dart';
import 'dart:developer' as developer;
import 'package:gkfit/widgets/loading/loadingIndicator.dart';
import 'package:gkfit/widgets/charts/time_series_chart_with_bar_renderer.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:gkfit/repository/CalorietrackerRepository.dart';
import 'package:gkfit/model/trackers/calorieTracker/entireDayMealModel.dart';

class CalorietrackerHomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CalorietrackerHomeScreenState();
}

class CalorietrackerHomeScreenState extends State<CalorietrackerHomeScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;
  CalorieIntakeBloc calorieIntakeBloc;
  User user;
  CalorieTrackerRepository _calorieTrackerRepository =
      CalorieTrackerRepository();
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    calorieIntakeBloc = BlocProvider.of<CalorieIntakeBloc>(context);
    developer.log(
      'calorie tracker home' +
          calorieIntakeBloc.state.entireDayMeal.dinner.toJson().toString(),
      name: 'calorie tracker home',
    );
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
      CalorieIntakeMiniDashBoard(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController,
            curve:
                Interval((1 / count) * 1, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: animationController,
      ),
    );
    listViews.add(
      JustTitleView(
        titleTxt: 'Track Your Calorie Intake',
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

    listViews.add(
      JustTitleView(
        titleTxt: 'Your Calorie Intake History',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: animationController,
            curve:
                Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: animationController,
        onclick: () {},
      ),
    );
    listViews.add(Container(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<charts.Series<TimeSeriesSales, DateTime>>>(
            future: _createWaterIntakeChart(),
            builder: (BuildContext context,
                AsyncSnapshot<List<charts.Series<TimeSeriesSales, DateTime>>>
                    snapshot) {
              if (snapshot.hasData) {
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

  Future<List<charts.Series<TimeSeriesSales, DateTime>>>
      _createWaterIntakeChart() async {
    List<EntireDayMealModel> autogen =
        await _calorieTrackerRepository.fetchEntireMealHistory(user.uid);
    List<TimeSeriesSales> data = [];
    autogen.forEach((element) {
      double totalcalories = element.breakfast.total_calories ??
          0 + element.morning_snack.total_calories ??
          0 + element.lunch.total_calories ??
          0 + element.evening_snack.total_calories ??
          0 + element.dinner.total_calories ??
          0;
      data.add(new TimeSeriesSales(
          DateTime.parse(element.date).toLocal(), totalcalories~/1000));
    });

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) =>
            new DateTime(sales.time.year, sales.time.month, sales.time.day),
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
