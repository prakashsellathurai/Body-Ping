import 'package:flutter/material.dart';
import 'package:gkfit/screens/dashboard/home/set_reminder/widgets/sliding_up_panel.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/services.dart';
import '../../dashboard_theme.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum WaterReminderOption { three_times, eight_times }

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
  bool isWaterDrinkReminderOn = false;
  double _cardMaxHeight = 0.0;
  double _cardMinHeight = 0.0;
  int _waterReminderOption;
  WaterReminderOption _groupvalue;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  List<Time> three_times = [
    Time(9, 0, 0),
    Time(12, 0, 0),
    Time(18, 0, 0),
  ];
  List<Time> eight_times =
      List.generate(12, (int index) => Time(9 + index, 30, 0));
  @override
  void initState() {
    getSharedPrefs();
    setLocalnotification();
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    _cardController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
  }

  Future<void> setLocalnotification() async {

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'Water Drink Reminder',
        'Water Drink Reminder',
        'repeatDailyAtTime description',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    if (_groupvalue == WaterReminderOption.three_times) {
      for (MapEntry entry in eight_times.asMap().entries) {
        await flutterLocalNotificationsPlugin.cancel(entry.key);
      }
      for (MapEntry entry in three_times.asMap().entries) {
        await flutterLocalNotificationsPlugin.showDailyAtTime(
            entry.key,
            'Water Reminder',
            'Hydrate Yourself',
            entry.value,
            platformChannelSpecifics);
      }
    } else {
      for (MapEntry entry in three_times.asMap().entries) {
        await flutterLocalNotificationsPlugin.cancel(entry.key);
      }
      for (MapEntry entry in eight_times.asMap().entries) {
        await flutterLocalNotificationsPlugin.showDailyAtTime(
            entry.key,
            'Water Reminder',
            'Hydrate Yourself',
            entry.value,
            platformChannelSpecifics);
      }
    }
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isWaterDrinkReminderOn = prefs.getBool("isWaterDrinkReminderOn") ?? false;
      _waterReminderOption = prefs.getInt("_waterReminderOption") ?? 0;
      _groupvalue = WaterReminderOption.values[_waterReminderOption];
    });
  }

  Future<Null> setSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isWaterDrinkReminderOn", isWaterDrinkReminderOn);
    prefs.setInt("_waterReminderOption", _waterReminderOption);
    _groupvalue = WaterReminderOption.values[_waterReminderOption];
    if (!isWaterDrinkReminderOn) {
      for (MapEntry entry in eight_times.asMap().entries) {
        await flutterLocalNotificationsPlugin.cancel(entry.key);
      }
    }
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
                            value: isWaterDrinkReminderOn,
                            onChanged: (value) {
                              setState(() {
                                isWaterDrinkReminderOn = value;
                                setSharedPrefs();
                              });
                            },
                            // activeTrackColor: Color(0xFF4FC1A6),
                            activeColor: Color(0xFF4FC1A6),
                          ),
                        ],
                      ),
                      if (isWaterDrinkReminderOn)
                        Column(
                          children: <Widget>[
                            SizedBox(height: 18),
                            // Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceAround,
                            //      crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: <Widget>[
                            //       Text(
                            //         "Set Reminder From",
                            //         textAlign: TextAlign.left,
                            //         style: TextStyle(
                            //           fontFamily: DashboardTheme.fontName,
                            //           fontWeight: FontWeight.w500,
                            //           fontSize: 14,
                            //           letterSpacing: 0.5,
                            //           color: DashboardTheme.lightText,
                            //         ),
                            //       ),
                            //       Text(
                            //         "Am",
                            //         textAlign: TextAlign.left,
                            //         style: TextStyle(
                            //           fontFamily: DashboardTheme.fontName,
                            //           fontWeight: FontWeight.w500,
                            //           fontSize: 14,
                            //           letterSpacing: 0.5,
                            //           color: DashboardTheme.lightText,
                            //         ),
                            //       ),
                            //       Text(
                            //         "To",
                            //         textAlign: TextAlign.left,
                            //         style: TextStyle(
                            //           fontFamily: DashboardTheme.fontName,
                            //           fontWeight: FontWeight.w500,
                            //           fontSize: 14,
                            //           letterSpacing: 0.5,
                            //           color: DashboardTheme.lightText,
                            //         ),
                            //       ),
                            //       Text(
                            //         "Pm",
                            //         textAlign: TextAlign.left,
                            //         style: TextStyle(
                            //           fontFamily: DashboardTheme.fontName,
                            //           fontWeight: FontWeight.w500,
                            //           fontSize: 14,
                            //           letterSpacing: 0.5,
                            //           color: DashboardTheme.lightText,
                            //         ),
                            //       ),
                            //     ]),
                            Column(
                              children: <Widget>[
                                RadioListTile<WaterReminderOption>(
                                  title: const Text('Three Times A day'),
                                  value: WaterReminderOption.three_times,
                                  groupValue: _groupvalue,
                                  onChanged: (WaterReminderOption value) {
                                    setState(() {
                                      _waterReminderOption = value.index;
                                      setSharedPrefs();
                                      setLocalnotification();
                                    });
                                  },
                                ),
                                RadioListTile<WaterReminderOption>(
                                  title: const Text(
                                      'Every one hour from 9.00 AM to 9.00 PM'),
                                  value: WaterReminderOption.eight_times,
                                  groupValue: _groupvalue,
                                  onChanged: (WaterReminderOption value) {
                                    setState(() {
                                      _waterReminderOption = value.index;
                                      setSharedPrefs();
                                      setLocalnotification();
                                    });
                                  },
                                ),
                              ],
                            ),
                            // Row(
                            //   children: <Widget>[
                            //     RaisedButton(
                            //       child: Text(
                            //           'Show plain notification with payload'),
                            //       onPressed: () async {
                            //         await _showNotification();
                            //       },
                            //     )
                            //   ],
                            // )
                          ],
                        )
                    ]),
                  )
                ],
              ),
            )));
  }

  Future<void> _showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        100, 'Water Reminder', 'Hydrate Yourself', platformChannelSpecifics,
        payload: 'item x');
  }
}
