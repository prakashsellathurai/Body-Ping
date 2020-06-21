import 'package:flutter/material.dart';
import 'package:gkfit/repository/user_repository.dart';
import 'package:gkfit/screens/register/register_screen.dart';


class CreateAccountButton extends StatelessWidget {


  CreateAccountButton({Key key})
      :
     
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
    
    SizedBox(
      height: 20,
      child:
    FlatButton(
      // padding: EdgeInsets.all(0),
    
      child: Text(
        'Create  Account',
        textAlign: TextAlign.end,
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return RegisterScreen();
          }),
        );
      },
    ));
  }
}
