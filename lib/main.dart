import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gkfit/bloc/home_bloc.dart';
import 'package:gkfit/screens/home.dart';
import 'package:gkfit/screens/login/login_screen.dart';
import 'package:gkfit/widgets/loading/loadingIndicator.dart';
import 'package:intercom_flutter/intercom_flutter.dart';

import 'package:flutter/material.dart';

import 'bloc/authentication/authentication_bloc.dart';
import 'bloc/simpleblocdelegate.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';

import 'bloc/trackers/bmi/bmi_bloc.dart';
import 'bloc/trackers/bmi/bmi_event.dart';
import 'bloc/trackers/calorieIntake/CalorieIntakeBloc.dart';
import 'bloc/trackers/calorieIntake/CalorieIntakeEvent.dart';
import 'bloc/trackers/water_intake/water_intake_bloc.dart';
import 'bloc/user_bloc.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

Future<void> main() async {
  // Fix for: Unhandled Exception: ServicesBinding.defaultBinaryMessenger was accessed before the binding was initialized.
  WidgetsFlutterBinding.ensureInitialized();

  notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  var initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/notification_ic');
  // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
  // of the `IOSFlutterLocalNotificationsPlugin` class
  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    selectNotificationSubject.add(payload);
  });

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  await Intercom.initialize('rv4ydr2y',
      iosApiKey: 'ios_sdk-152bd9bbc8dc994be0b581e706b97a7bfbd7f3cd',
      androidApiKey: 'android_sdk-00787217d80052b3eee2d51235c22e803a521dce');
  BlocSupervisor.delegate = SimpleBlocDelegate();

  runApp(BlocProvider(
      create: (context) => AuthenticationBloc()..add(AuthenticationStarted()),
      child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final MethodChannel platform =
      MethodChannel('crossingthestreams.io/resourceResolver');

  @override
  void initState() {
    super.initState();
    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                print("recieved cupertino");
                // Navigator.of(context, rootNavigator: true).pop();
                // await Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) =>
                //         HomePage(),
                //   ),
                // );
              },
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      print("recieved rx subject");
      // await Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => HomePage()),
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        bloc: BlocProvider.of<AuthenticationBloc>(context),

        builder: (context, state) {
          if (state is AuthenticationProcessing) {
            return Scaffold(
              body: Center(
                child: LoadingIndicator(),
              ),
            );
          }
          if (state is AuthenticationLoggedOut) {
            return LoginScreen();
          }
          if (state is AuthenticationFailure) {
            return LoginScreen();
          }
          if (state is AuthenticationSuccess) {
            return _buildHomePage(state.user.uid);
          }

          return Scaffold(
            body: Center(
              child: LoadingIndicator(),
            ),
          );
        },
      ),
    );
  }
}

Widget _buildHomePage(uid) {
  return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(uid: uid)..add(UserFetch()),
        ),
        BlocProvider<WaterIntakeBloc>(
          create: (context) =>
              WaterIntakeBloc(uid: uid)..add(FetchWaterIntakeEvent()),
        ),
        BlocProvider<CalorieIntakeBloc>(
          create: (context) =>
              CalorieIntakeBloc(uid: uid)..add(FetchEntiredayMealModelEvent()),
        ),
        BlocProvider<BmiBloc>(
          create: (context) => BmiBloc(uid: uid)..add(FetchBMI()),
        ),
      ],
      child: MaterialApp(
          theme: ThemeData(primarySwatch: Colors.indigo),
          home: BlocProvider<HomeBloc>(
              create: (context) => HomeBloc(
                  userBloc: BlocProvider.of<UserBloc>(context),
                  bmiBloc: BlocProvider.of<BmiBloc>(context),
                  calorieIntakeBloc:
                      BlocProvider.of<CalorieIntakeBloc>(context),
                  waterIntakeBloc: BlocProvider.of<WaterIntakeBloc>(context))
                ..add(HomeEvent.appStarted),
              child: MaterialApp(
                theme: ThemeData(primarySwatch: Colors.indigo),
                home: HomePage(),
              ))));
}
