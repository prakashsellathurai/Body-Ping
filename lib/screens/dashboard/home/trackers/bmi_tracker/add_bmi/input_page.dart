import 'package:gkfit/screens/dashboard/home/trackers/bmi_tracker/add_bmi/bodyfat/bodyfatCard.dart';

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
          appBar: PreferredSize(
            child: BmiAppBar(),
            preferredSize: Size.fromHeight(appBarHeight(context)),
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
      child: PacmanSlider(
        submitAnimationController: _submitAnimationController,
        onSubmit: onPacmanSubmit,
      ),
    );
  }

  void onPacmanSubmit() {
    _submitAnimationController.forward();
  }

  _goToResultPage() async {
    return Navigator.of(context).push(FadeRoute(
      builder: (context) => ResultPage(
            weight: weight,
            height: height,
            bodyfat: bodyfat
          ),
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
