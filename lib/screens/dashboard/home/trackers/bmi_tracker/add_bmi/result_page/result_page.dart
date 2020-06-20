import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gkfit/bloc/trackers/bmi/bmi_bloc.dart';
import 'package:gkfit/bloc/trackers/bmi/bmi_event.dart';
import 'package:gkfit/screens/dashboard/home/trackers/bmi_tracker/bmi_tracker_home.dart';

import '../app_bar.dart';
import '../calculator.dart' as calculator;
import '../input_page_styles.dart';
import 'package:gkfit/bloc/user_bloc.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  final int height;
  final int weight;
  final int bodyfat;

  const ResultPage({
    Key key,
    this.height,
    this.weight,
    this.bodyfat,
  }) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        child: BmiAppBar(isInputPage: false),
        preferredSize: Size.fromHeight(appBarHeight(context)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ResultCard(
            bmi: calculator.calculateBMI(
                height: widget.height, weight: widget.weight),
            minWeight:
                calculator.calculateMinNormalWeight(height: widget.height),
            maxWeight:
                calculator.calculateMaxNormalWeight(height: widget.height),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Padding(
          //   padding: const EdgeInsets.only(right: 40.0),
          //   child: IconButton(
          //     icon: Icon(
          //       Icons.delete,
          //       color: Colors.grey,
          //       size: 28.0,
          //     ),
          //     onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          //         builder: (context) => BmitrackerHomeScreen())),
          //   ),
          // ),
          // Container(
          //     height: 52.0,
          //     width: 80.0,
          //     child: RaisedButton(
          //       child: Icon(
          //         Icons.refresh,
          //         color: Colors.white,
          //         size: 28.0,
          //       ),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(6.0),
          //       ),
          //       onPressed: () => Navigator.of(context).pop(),
          //       color: Theme.of(context).primaryColor,
          //     )),
          Padding(
            padding: const EdgeInsets.all( 4.0),
            child: RaisedButton.icon(
              label: Text("click here to log"),
              icon: Icon(
                Icons.add,
                color: Colors.grey,
                size: 40.0,
              ),
              onPressed: () {
                BmiBloc _bmibloc = BlocProvider.of<BmiBloc>(context);
                UserBloc _userbloc = BlocProvider.of<UserBloc>(context);
                print(_userbloc.state.getUserData());
                _bmibloc
                  ..add(AddBMI(
                      lastLoggedTime: DateTime.now().toUtc().toIso8601String(),
                      weight_in_kgs: widget.weight.toDouble(),
                      bmi: calculator.calculateBMI(
                          height: widget.height, weight: widget.weight),
                      height_in_cm: widget.height.toDouble(),
                      bodyfat: widget.bodyfat.toDouble()))
                      ..add(UpdateBMI());
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BmitrackerHomeScreen()));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ResultCard extends StatelessWidget {
  final double bmi;
  final double minWeight;
  final double maxWeight;

  ResultCard({Key key, this.bmi, this.minWeight, this.maxWeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Container(
          width: double.infinity,
          child: Column(children: [
            Text(
              '🔥',
              style: TextStyle(fontSize: 80.0),
            ),
            Text(
              bmi.toStringAsFixed(1),
              style: TextStyle(fontSize: 140.0, fontWeight: FontWeight.bold),
            ),
            Text(
              'BMI = ${bmi.toStringAsFixed(2)} kg/m²',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                'Normal BMI weight range for the height:\n${minWeight.round()}kg - ${maxWeight.round()}kg',
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
