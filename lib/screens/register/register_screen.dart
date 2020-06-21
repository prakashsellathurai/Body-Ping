import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gkfit/bloc/register/register_bloc.dart';
import 'package:gkfit/repository/user_repository.dart';
import 'package:gkfit/screens/register/register_form.dart';
import 'package:gkfit/widgets/animations/delayed_animation.dart';
import 'package:flutter/services.dart';
import 'package:avatar_glow/avatar_glow.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final UserRepository _userRepository = UserRepository();
  double _appBarBottomPadding = 22.0;
  double _appBarHorizontalPadding = 28.0;
  double _appBarTopPadding = 45.0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          _card(context),
          SizedBox(height: 9),
          _buildAppBar(context),
        ],
      ),
    );
  }

  Widget _card(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height * 0.78;

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
                      // SizedBox(height: 18),
                      topContent(),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: BlocProvider<RegisterBloc>(
                          create: (context) =>
                              RegisterBloc(userRepository: _userRepository),
                          child: RegisterForm(),
                        ),
                      )
                    ]),
                  )
                ],
              ),
            )));
  }

  Widget topContent() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 32.0),
          DelayedAnimation(
            child: _buildHeader(),
            delay: 2,
          ),
          // DelayedAnimation(
          //   child: Text(
          //     "Hi There",
          //     textAlign: TextAlign.center,
          //     style: TextStyle(
          //         fontWeight: FontWeight.bold,
          //         fontSize: 35.0,
          //         color: Colors.black54),
          //   ),
          //   delay: delayedAmount + 1000,
          // ),
          // SizedBox(height: 15.0),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    double scaleFactor = .35;
    return AvatarGlow(
        duration: Duration(seconds: 2),
        glowColor: Colors.teal,
        repeat: true,
        repeatPauseDuration: Duration(seconds: 2),
        startDelay: Duration(seconds: 1),
        child: Material(
            elevation: 8.0,
            shape: CircleBorder(),
            child: CircleAvatar(
              backgroundColor: Colors.teal[100], //Colors.grey[100],
              radius: 50.0,
              child: Image(
                width: MediaQuery.of(context).size.width * scaleFactor,
                height: MediaQuery.of(context).size.height * scaleFactor,
                image: AssetImage('assets/images/logo.png'),
                fit: BoxFit.fill,
              ),
            )),
        endRadius: 90);
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
            Container(
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.black),
                onPressed: Navigator.of(context).pop,
              ),
            )
          ],
        ),
      ]),
    );
  }
}
