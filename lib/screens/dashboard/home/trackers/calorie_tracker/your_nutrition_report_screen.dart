import 'package:flutter/material.dart';
import 'package:gkfit/widgets/error/no_internet.dart';
import 'package:gkfit/widgets/loading/loadingIndicator.dart';
import '../../../dashboard_theme.dart';
class YourNutritionReportScreen extends StatefulWidget {
  YourNutritionReportScreen({Key key}) : super(key: key);

  @override
  _YourNutritionReportScreenState createState() => _YourNutritionReportScreenState();
}

class _YourNutritionReportScreenState extends State<YourNutritionReportScreen> {
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
            "Your Nutrition report",
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: Colors.black),
          ),
        ),
       body: Center(
         child:NoInternet()
       ),
    );
  }
}