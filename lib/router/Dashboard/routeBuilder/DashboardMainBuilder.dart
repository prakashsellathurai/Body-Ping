
import 'package:gkfit/bloc/user_bloc.dart';
import 'package:gkfit/model/userDataModel.dart';
import 'package:gkfit/screens/dashboard/dashboard_screen.dart';
import 'package:gkfit/services/auth_service.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class DashBoardMainBuilder extends StatelessWidget{
  final UserDataModel userData;

  const DashBoardMainBuilder({Key key, this.userData}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
         return AppDashboardHomeScreen(
                      user: user, userData: userData);
  }

}