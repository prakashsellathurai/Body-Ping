import 'package:gkfit/screens/dashboard/dashboard_theme.dart';
import 'package:gkfit/screens/dashboard/home/trackers/bmi_tracker/add_bmi/bodyfat/bodyfatCard.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gkfit/bloc/trackers/bmi/bmi_bloc.dart';
import 'package:gkfit/bloc/trackers/bmi/bmi_event.dart';

import 'calculator.dart' as calculator;

import './app_bar.dart';
import './utils/fade_route.dart';
import './gender/gender_card.dart';
import './height/height_card.dart';
import './input_page_styles.dart';
import './pacman_slider.dart';
import './transition_dot.dart';
import './weight/weight_card.dart';
import './model/gender.dart';
import './result_page/result_page.dart';
import './utils/widget_utils.dart';
import 'package:flutter/material.dart';

class InputPage extends StatefulWidget {
  @override
  InputPageState createState() {
    return new InputPageState();
  }
}

class InputPageState extends State<InputPage> with TickerProviderStateMixin {
  AnimationController _submitAnimationController;
  Gender gender = Gender.other;
  int height = 180;
  int weight = 70;
  int bodyfat = 20;

  @override
  void initState() {
    super.initState();
    _submitAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _submitAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _goToResultPage().then((_) => _submitAnimationController.reset());
      }
    });
  }

  @override
  void dispose() {
    _submitAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
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
                Navigator.of(context).pop();
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
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InputSummaryCard(
                bodyfat: bodyfat,
                weight: weight,
                height: height,
              ),
              Expanded(child: _buildCards(context)),
              _buildBottom(context),
            ],
          ),
        ),
        TransitionDot(animation: _submitAnimationController),
      ],
    );
  }

  Widget _buildCards(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              Expanded(
                child: BodyFat(
                  bodyfat: bodyfat,
                  onChanged: (val) => setState(() => bodyfat = val),
                ),
              ),
              Expanded(
                child: WeightCard(
                  weight: weight,
                  onChanged: (val) => setState(() => weight = val),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: HeightCard(
            height: height,
            onChanged: (val) => setState(() => height = val),
          ),
        )
      ],
    );
  }

  Widget _buildBottom(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: screenAwareSize(16.0, context),
        right: screenAwareSize(16.0, context),
        bottom: screenAwareSize(22.0, context),
        top: screenAwareSize(14.0, context),
      ),
      child: weightSubmit(context),
    );
  }

  Widget weightSubmit(context) {
    return Center(
        child: Container(
      padding: const EdgeInsets.all(2),
      width: MediaQuery.of(context).size.width * .9,
      height: screenAwareSize(52, context),
      child: RaisedButton(
        color: Theme.of(context).primaryColor,
        child: Text(
          "Click Here to Log Your Weight",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          BmiBloc _bmibloc = BlocProvider.of<BmiBloc>(context);

          _bmibloc
            ..add(AddBMI(
                lastLoggedTime: DateTime.now().toUtc().toIso8601String(),
                weight_in_kgs: weight.toDouble(),
                bmi: calculator.calculateBMI(height: height, weight: weight),
                height_in_cm: height.toDouble(),
                bodyfat: bodyfat.toDouble()))
            ..add(UpdateBMI());
          Navigator.of(context).pop();
        },
      ),
    ));
  }

  void onPacmanSubmit() {
    _submitAnimationController.forward();
  }

  _goToResultPage() async {
    return Navigator.of(context).push(FadeRoute(
      builder: (context) =>
          ResultPage(weight: weight, height: height, bodyfat: bodyfat),
    ));
  }
}

class InputSummaryCard extends StatelessWidget {
  final int bodyfat;
  final int height;
  final int weight;

  const InputSummaryCard({Key key, this.bodyfat, this.height, this.weight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(screenAwareSize(16.0, context)),
      child: SizedBox(
        height: screenAwareSize(32.0, context),
        child: Row(
          children: <Widget>[
            Expanded(child: _text("${bodyfat}%")),
            _divider(),
            Expanded(child: _text("${weight}kg")),
            _divider(),
            Expanded(child: _text("${height}cm")),
          ],
        ),
      ),
    );
  }

  // Widget _genderText() {
  //   String genderText = gender == Gender.other
  //       ? '-'
  //       : (gender == Gender.male ? 'Male' : 'Female');
  //   return _text(genderText);
  // }

  Widget _text(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Color.fromRGBO(143, 144, 156, 1.0),
        fontSize: 15.0,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _divider() {
    return Container(
      width: 1.0,
      color: Color.fromRGBO(151, 151, 151, 0.1),
    );
  }
}
