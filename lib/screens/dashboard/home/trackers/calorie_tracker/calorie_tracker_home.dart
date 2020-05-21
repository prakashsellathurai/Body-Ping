import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../dashboard_theme.dart';

class CalorietrackerHomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => CalorietrackerHomeScreenState();

}
class CalorietrackerHomeScreenState extends State<CalorietrackerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar:AppBar(
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
      body:Text("calorie")
    );
  }

}