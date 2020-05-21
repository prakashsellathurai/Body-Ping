import 'package:gkfit/bloc/user_bloc.dart';
import 'package:gkfit/model/userDataModel.dart';
import 'package:gkfit/provider/userDataProviderApiClient.dart';
import 'package:gkfit/screens/home.dart';
import 'package:gkfit/widgets/loading/loadingIndicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserSubmitLoadingPage extends StatelessWidget {
  Future<UserDataModel> userData;
  UserDataProviderApiClient userdataprovider = new UserDataProviderApiClient();
  Map<String, dynamic> submittedData;
  String uid;

  UserDataModel responseData;

  UserBloc userBloc;
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
                    return goToHomeUntilUserState(context);
                  } else if (!snapshot.hasData) {
                    return LoadingIndicator();
                  } else if (snapshot.error) {
                    return showAlertDialog(
                        context, 'Alert', "Error connecting to server");
                  }
                  return LoadingIndicator();
                })));
  }

  Widget goToHomeUntilUserState(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);
    userBloc.fetchUser();
    return StreamBuilder(
        stream: userBloc.userData,
        builder:
            (BuildContext context, AsyncSnapshot<UserDataModel> asyncSnapshot) {
          if (asyncSnapshot.hasData) {
            if (asyncSnapshot.data.dateofbirth != '' ||
                asyncSnapshot.data.dateofbirth != null ||
                asyncSnapshot.data.dateofbirth.isNotEmpty) {
              userBloc.add(UserFetch());
              return HomePage();
            } else {
              userBloc.fetchUser();
              userBloc.add(UserFetch());
            }
          } else {
            return LoadingIndicator();
          }
          return LoadingIndicator();
        });
  }

  Future<bool> fetchUserdata() async {
    print("checking serve");
    try {
      UserDataModel userdata =
          await userdataprovider.createUser(uid, submittedData);
      print(userdata.toJson);
      return true;
    } catch (e) {
      print("post failed");
    }
  }
}
