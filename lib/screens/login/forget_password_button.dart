import 'package:flutter/material.dart';
import 'package:gkfit/screens/forget_password/forget_password_screen.dart';

class ForgetPasswordButton extends StatelessWidget {
  ForgetPasswordButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 20,
        child: FlatButton(
          child: Text(
            'Forget Password',
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return ForgetPasswordScreen();
              }),
            );
          },
        ));
  }
}
