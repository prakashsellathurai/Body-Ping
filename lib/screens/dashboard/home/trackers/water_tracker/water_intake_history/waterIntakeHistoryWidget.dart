import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gkfit/bloc/trackers/water_intake/water_intake_bloc.dart';

import 'package:gkfit/widgets/charts/time_series_chart_with_bar_renderer.dart';

import 'package:charts_flutter/flutter.dart' as charts;

class WaterIntakeHistoryWidget extends StatefulWidget {
  final List<charts.Series<TimeSeriesSales, DateTime>> data;

  WaterIntakeHistoryWidget({
    Key key,
    this.data,
  }) : super(key: key);

  @override
  _WaterIntakeHistoryWidgetState createState() =>
      _WaterIntakeHistoryWidgetState();
}

class _WaterIntakeHistoryWidgetState extends State<WaterIntakeHistoryWidget> {
  WaterIntakeBloc waterIntakebloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    waterIntakebloc = BlocProvider.of<WaterIntakeBloc>(context);

    return Container(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<charts.Series<TimeSeriesSales, DateTime>>>(
            initialData: widget.data,
            builder: (BuildContext context,
                AsyncSnapshot<List<charts.Series<TimeSeriesSales, DateTime>>>
                    snapshot) {
              return new TimeSeriesBar(
                snapshot.data,
                animate: true,
              );
            },
          ),
        ));
  }
}
