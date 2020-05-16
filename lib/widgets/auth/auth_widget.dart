import 'package:customer_app/bloc/user_bloc.dart';
import 'package:customer_app/widgets/loading/loadingIndicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './../../screens/home.dart';
import './../../screens/sign_in/sign_in_page.dart';
import './../../services/auth_service.dart';
import 'package:flutter/material.dart';


class AuthWidget extends StatelessWidget {
  const AuthWidget({Key key, @required this.userSnapshot}) : super(key: key);
  final AsyncSnapshot<User> userSnapshot;

  @override
  Widget build(BuildContext context) {
    if (userSnapshot.connectionState == ConnectionState.active) {
      return userSnapshot.hasData ? _buildHomePage(context,userSnapshot): SignInPageBuilder();
    }
    return Scaffold(
      body: Center(
        child: LoadingIndicator(),
      ),
    );
  }
  Widget _buildHomePage(BuildContext context, AsyncSnapshot<User> userSnapshot) {
    return BlocProvider(
      create: (context) => UserBloc(uid: userSnapshot.data.uid)..add(UserFetch()),
      child: HomePage());
  }
}
