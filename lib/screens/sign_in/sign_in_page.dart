import 'package:avatar_glow/avatar_glow.dart';
import 'package:gkfit/constants/keys.dart';
import 'package:gkfit/screens/sign_in/email_password/email_password_sign_in_model.dart';
import 'package:gkfit/screens/walk_through/walk_through_screen.dart';
import 'package:gkfit/widgets/animations/delayed_animation.dart';
import 'package:gkfit/widgets/animations/transition_dot.dart';
import 'package:gkfit/widgets/exceptions/platform_exception_alert_dialog.dart';
import 'package:gkfit/widgets/loading/loadingIndicator.dart';
import 'package:gkfit/widgets/ui/home_page_curve.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './email_password/email_password_sign_in_page.dart';
import './email_link/email_link_sign_in_page.dart';
import './sign_in_manager.dart';
import './../../constants/strings.dart';
import './../../services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

final kLabelStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

class SignInPageBuilder extends StatelessWidget {
  // P<ValueNotifier>
  //   P<SignInManager>(valueNotifier)
  //     SignInPage(value)
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of<AuthService>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, ValueNotifier<bool> isLoading, __) =>
            Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (_, SignInManager manager, __) => SignInPage._(
              isLoading: isLoading.value,
              manager: manager,
              title: 'customer-app',
            ),
          ),
        ),
      ),
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage._({Key key, this.isLoading, this.manager, this.title})
      : super(key: key);
  final SignInManager manager;
  final String title;
  final bool isLoading;

  @override
  State<StatefulWidget> createState() {
    return SignInPageState._(isLoading, manager, title);
  }
}

class SignInPageState extends State<SignInPage> with TickerProviderStateMixin {
  SignInPageState._(this.isLoading, this.manager, this.title);
  final SignInManager manager;
  final String title;
  final bool isLoading;
  double _scale;
  final int delayedAmount = 500;

  AnimationController _loadingAnimationController;
  @override
  void initState() {
    _loadingAnimationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  Future<void> onsignInWithEmailPageSubmit() async {
    await _signInWithEmailAndPassword(context);
  }

  Future<void> onsignInWithGoogle() async {
    await _signInWithGoogle(context);
  }

  void _onTapDown(TapDownDetails details) {
    _loadingAnimationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _loadingAnimationController.reverse();
  }

  @override
  void dispose() {
    _loadingAnimationController.dispose();
    super.dispose();
  }

  Future<bool> checkWalkThroughScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return (prefs.getBool(Keys.showWalkthrough) ?? true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkWalkThroughScreen(),
      builder:
          (BuildContext context, AsyncSnapshot<bool> showWalkThroughScreen) {
        if (showWalkThroughScreen.hasData) {
          if (showWalkThroughScreen.data) {
            return WalkThroughScreen();
          } else {
            return Scaffold(
                backgroundColor: Colors.white, //Colors.grey[200],
                body: Center(
                  child: _buildSignIn(context),
                ));
          }
        } else {
          return LoadingIndicator();
        }
      },
    );
  }

  Widget _buildSignIn(BuildContext context) {
    // Make content scrollable so that it fits on small screens
    return Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              topContent(),
              midContent(),
              bottomContent(),
            ]));
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
          DelayedAnimation(
            child: Text(
              "Hi There",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35.0,
                  color: Colors.black54),
            ),
            delay: delayedAmount + 1000,
          ),
        ],
      ),
    );
  }

  Widget midContent() {
    return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[],
        ));
  }

  Widget bottomContent() {
    return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DelayedAnimation(
              child: _googleButton(context),
              delay: delayedAmount + 2000,
            ),
            SizedBox(height: 15.0),
            DelayedAnimation(
              child: _buildSignInWithText(),
              delay: delayedAmount + 3000,
            ),
            SizedBox(height: 15.0),
            DelayedAnimation(
              child: _signInWithEmailButton(context),
              delay: delayedAmount + 4000,
            ),
            SizedBox(height: 40.0),
          ],
        ));
  }

  Widget _buildHeader() {
    if (isLoading) {
      return Center(
        child: LoadingIndicator(),
      );
    }
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
              backgroundColor: Colors.teal[100],//Colors.grey[100],
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

  Widget _signInWithEmailButton(BuildContext context) {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () => isLoading ? null : onsignInWithEmailPageSubmit(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.email),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Email',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showSignInError(
      BuildContext context, PlatformException exception) async {
    await PlatformExceptionAlertDialog(
      title: Strings.signInFailed,
      exception: exception,
    ).show(context);
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on PlatformException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    final navigator = Navigator.of(context);
    await EmailPasswordSignInPage.show(
      context,
      EmailPasswordSignInFormType.signIn,
      onSignedIn: navigator.pop,
    );
  }

  Future<void> _signInWithEmailLink(BuildContext context) async {
    final navigator = Navigator.of(context);
    await EmailLinkSignInPage.show(
      context,
      onSignedIn: navigator.pop,
    );
  }

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- OR -',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _googleButton(BuildContext context) {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () => isLoading ? null : onsignInWithGoogle(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/images/g-logo.png"), height: 20.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
