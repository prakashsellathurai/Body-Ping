import 'package:flutter/material.dart';
import '../../../dashboard_theme.dart';

class AddMealScreen extends StatefulWidget {

String meal_title;
AddMealScreen({this.meal_title});
  @override
  _AddMealScreenState createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {


  @override
  Widget build(BuildContext context) {
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
            'Add '+widget.meal_title,
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: Colors.black),
          ),
        ),
      body: Text("add meal"),
    );
  }
}
