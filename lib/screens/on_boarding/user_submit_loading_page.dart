import 'package:customer_app/model/userDataModel.dart';
import 'package:customer_app/provider/userDataProviderApiClient.dart';
import 'package:customer_app/screens/home.dart';
import 'package:customer_app/widgets/loading/loadingIndicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserSubmitLoadingPage extends StatelessWidget {
  Future<UserDataModel> userData;
  UserDataProviderApiClient userdataprovider = new UserDataProviderApiClient();
  Map<String, dynamic> submittedData;
  String uid;

  UserDataModel responseData;
  UserSubmitLoadingPage(this.uid, this.submittedData);

  Widget showAlertDialog(BuildContext context, String title, String message) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: FutureBuilder<bool>(
                future: fetchUserdata(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return HomePage();
                  } else if (!snapshot.hasData) {
                    return LoadingIndicator();
                  } else if (snapshot.error) {
                    return showAlertDialog(
                        context, 'Alert', "Error connecting to server");
                  }
                  return LoadingIndicator();
                })));
  }

  Future<bool> fetchUserdata() async {
    print("checking serve");
    try {
      await userdataprovider.createUser(uid, submittedData);
      print("success");
    } catch (e) {
      print("post failed");
    }

    return true;
  }
}
