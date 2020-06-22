import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gkfit/bloc/trackers/water_intake/water_intake_model.dart';
import 'package:gkfit/bloc/trackers/water_intake/water_intake_repository.dart';
import 'package:gkfit/model/trackers/weight_tracker/weight_tracker_model.dart';
import 'package:gkfit/repository/weight_tracker_repository.dart';
import 'package:gkfit/screens/dashboard/home/trackers/water_tracker/history/models/balance.dart';
import 'package:gkfit/widgets/charts/time_series_chart_with_bar_renderer.dart';
import 'package:gkfit/widgets/ui/blog_list_loader.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gkfit/bloc/authentication/authentication_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
class BmIHistoryWidget extends StatefulWidget {
  BmIHistoryWidget({Key key}) : super(key: key);

  @override
  _BmIHistoryWidgetState createState() => _BmIHistoryWidgetState();
}

class _BmIHistoryWidgetState extends State<BmIHistoryWidget> {
  WeightTrackerRepository _weightTrackerRepository = WeightTrackerRepository();
  FirebaseUser  user;
  List<charts.Series<Balance, String>> series;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = BlocProvider.of<AuthenticationBloc>(context).state.user;
    return Container(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<charts.Series<TimeSeriesSales, DateTime>>>(
            future: _createWaterIntakeChart(),
            builder: (BuildContext context,
                AsyncSnapshot<List<charts.Series<TimeSeriesSales, DateTime>>>
                    snapshot) {
              if (snapshot.hasData) {
                return new charts.TimeSeriesChart(
                  snapshot.data,
                  animate: true,
                );
              }
              return BlogLisLoader(
                length: 1,
              );
            },
          ),
        ));
  }

  Future<List<charts.Series<TimeSeriesSales, DateTime>>>
      _createWaterIntakeChart() async {
    DateTime today = DateTime.now();
    DateTime fiveDaysafter = today.add(new Duration(days: 2)).toUtc();
    DateTime fiveDaysBefore = today.subtract(new Duration(days: 2)).toUtc();
    print(today);
    print(fiveDaysBefore);
    List<WeightTrackerModel> autogen =
        await _weightTrackerRepository.getHistory(user.uid,
            fiveDaysBefore.toIso8601String(), fiveDaysafter.toIso8601String());
    List<TimeSeriesSales> data = [];
    autogen.forEach((element) {
      data.add(new TimeSeriesSales(DateTime.parse(element.time).toLocal(),
          element.weight_in_kgs.toInt()));
    });
    print(data);
    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time.toLocal(),
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}
