import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gkfit/bloc/authentication/authentication_bloc.dart';
import 'package:gkfit/bloc/login/login_bloc.dart';
import 'package:gkfit/bloc/login/login_event.dart';
import 'package:gkfit/bloc/login/login_state.dart';
import 'package:gkfit/repository/user_repository.dart';
import 'package:gkfit/widgets/animations/delayed_animation.dart';
import 'package:gkfit/widgets/loading/loadingIndicator.dart';

import 'create_account_button.dart';
import 'google_login_button.dart';
import 'login_button.dart';
import 'forget_password_button.dart';

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;

  LoginForm({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  AnimationController _loadingAnimationController;
  LoginBloc _loginBloc;
  double _scale;
  final int delayedAmount = 500;
  UserRepository get _userRepository => widget._userRepository;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
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
  }

  void _onTapDown(TapDownDetails details) {
    _loadingAnimationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _loadingAnimationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Login Failure'), Icon(Icons.error)],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Logging In...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context)
              .add(AuthenticationLogIn());
        }
      
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned(
                top: MediaQuery.of(context).size.height * .45,
                child: Container(
                  height: MediaQuery.of(context).size.height * .55,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(20.0),
                  child: Form(
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        // topContent(),
                        DelayedAnimation(
                          child: TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              icon: Icon(Icons.email),
                              labelText: 'Email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autovalidate: true,
                            autocorrect: false,
                            validator: (_) {
                              return !state.isEmailValid
                                  ? 'Invalid Email'
                                  : null;
                            },
                          ),
                          delay: delayedAmount + 1000,
                        ),
                        DelayedAnimation(
                          child: TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              icon: Icon(Icons.lock),
                              labelText: 'Password',
                            ),
                            obscureText: true,
                            autovalidate: true,
                            autocorrect: false,
                            validator: (_) {
                              return !state.isPasswordValid
                                  ? 'Invalid Password'
                                  : null;
                            },
                          ),
                          delay: delayedAmount + 2000,
                        ),
                        DelayedAnimation(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                SizedBox(height: 32.0),
                                LoginButton(
                                  onPressed: isLoginButtonEnabled(state)
                                      ? _onFormSubmitted
                                      : null,
                                ),
                                SizedBox(height: 15.0),
                                _buildSignInWithText(),
                                SizedBox(height: 15.0),
                                GoogleLoginButton(),
                                SizedBox(height: 15.0),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    ForgetPasswordButton(),
                                    CreateAccountButton(),
                                  ],
                                )
                              ],
                            ),
                          ),
                          delay: delayedAmount + 3000,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                  child: Align(
                alignment: Alignment.topCenter,
                child: topContent(context),
              ))
            ],
          );
        },
      ),
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

  Widget topContent(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .45,
      margin: const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
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
                  fontSize: MediaQuery.of(context).size.width * .085,
                  color: Colors.black54),
            ),
            delay: delayedAmount + 1000,
          ),
          SizedBox(height: 32.0),
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _loginBloc.add(
      LoginEmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _loginBloc.add(
      LoginPasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _loginBloc.add(
      LoginWithCredentialsPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}
