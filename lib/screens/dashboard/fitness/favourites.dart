import 'package:flutter/material.dart';

class FavouritesFitnessScreen extends StatefulWidget {
  FavouritesFitnessScreen({Key key}) : super(key: key);

  @override
  _FavouritesFitnessScreenState createState() =>
      _FavouritesFitnessScreenState();
}

class _FavouritesFitnessScreenState extends State<FavouritesFitnessScreen> {
  double _appBarBottomPadding = 22.0;
  double _appBarHorizontalPadding = 28.0;
  double _appBarTopPadding = 60.0;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF4FC1A6),
      body: Stack(
        children: <Widget>[
          _buildAppBar(context),
          SizedBox(height: 9),
          _card(context)
        ],
      ),
    );
  }

  Widget _card(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height * 0.83;

    return new Positioned(
        child: new Align(
            alignment: FractionalOffset.bottomCenter,
            child: Container(
              width: screenWidth,
              height: screenHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: <Widget>[
                  SingleChildScrollView(
                      padding:
                          EdgeInsets.symmetric(vertical: 19, horizontal: 27),
                      physics: BouncingScrollPhysics(),
                      child: Column(children: <Widget>[
                        SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[],
                        ),
                      ]))
                ],
              ),
            )));
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: _appBarHorizontalPadding,
        right: _appBarHorizontalPadding,
        top: _appBarTopPadding,
        bottom: _appBarBottomPadding,
      ),
      child: Stack(alignment: Alignment.center, children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              child: Icon(Icons.close, color: Colors.white),
              onTap: Navigator.of(context).pop,
            ),
          ],
        ),
      ]),
    );
  }
}
