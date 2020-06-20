import 'package:flutter/material.dart';
import 'package:gkfit/screens/dashboard/home/set_reminder/widgets/sliding_up_panel.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/services.dart';
import '../../dashboard_theme.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SetRemainderScreen extends StatefulWidget {
  SetRemainderScreen({Key key}) : super(key: key);

  @override
  _SetRemainderScreenState createState() => _SetRemainderScreenState();
}

class _SetRemainderScreenState extends State<SetRemainderScreen>
    with TickerProviderStateMixin {
  double _appBarBottomPadding = 22.0;
  double _appBarHorizontalPadding = 28.0;
  double _appBarTopPadding = 60.0;
  AnimationController _cardController;
  bool isSwitched = false;
  double _cardMaxHeight = 0.0;
  double _cardMinHeight = 0.0;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    _cardController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    super.initState();
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
                    padding: EdgeInsets.symmetric(vertical: 19, horizontal: 27),
                    physics: BouncingScrollPhysics(),
                    child: Column(children: <Widget>[
                      SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Set Water Remainder",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: DashboardTheme.fontName,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              letterSpacing: 0.5,
                              color: DashboardTheme.lightText,
                            ),
                          ),
                          Switch(
                            value: isSwitched,
                            onChanged: (value) {
                              setState(() {
                                isSwitched = value;
                              });
                            },
                            // activeTrackColor: Color(0xFF4FC1A6),
                            activeColor: Color(0xFF4FC1A6),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          RaisedButton(
                            child: Text('Show plain notification with payload'),
                            onPressed: () async {
                              await _showNotification();
                            },
                          )
                        ],
                      )
                    ]),
                  )
                ],
              ),
            )));

    ;
  }

  Future<void> _showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }
}
