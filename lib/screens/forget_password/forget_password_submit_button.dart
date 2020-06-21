import 'package:flutter/material.dart';

class ForgetPasswordSubmitButton extends StatelessWidget {
  final VoidCallback _onPressed;

  ForgetPasswordSubmitButton({Key key, VoidCallback onPressed})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return    Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        key: Key('primary-button'),
        elevation: 5.0,
        onPressed: _onPressed,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
         'Send Password Reset Email',
          style: TextStyle(
            color: Color(0xFF253840),
            letterSpacing: 1.5,
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
}
