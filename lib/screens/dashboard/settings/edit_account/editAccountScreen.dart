import 'package:gkfit/bloc/user_bloc.dart';
import 'package:gkfit/constants/colors.dart';
import 'package:gkfit/constants/strings.dart';
import 'package:gkfit/model/userDataModel.dart';

import 'package:gkfit/screens/home.dart';
import 'package:gkfit/widgets/exceptions/platform_alert_dialog.dart';
import 'package:gkfit/widgets/topbar/edit_account_topbar.dart';
import 'package:gkfit/widgets/ui/blog_list_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:international_phone_input/international_phone_input.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:gkfit/provider/userDataProviderApiClient.dart';
final kHintTextStyle = TextStyle(
  color: Colors.grey, //Colors.white54,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Color(0xFF253840),
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: base_color_monochrome_1, //Color(0xFF41B4BC),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

class EditAccountScreen extends StatefulWidget {
  UserDataModel userData;
  EditAccountScreen(this.userData);

  @override
  _EditAccountScreenState createState() => _EditAccountScreenState(userData);
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  UserDataModel userData;
  UserBloc userbloc;
  String firstNamePlaceholder,lastNamePlaceholder,
      emailplaceholder,
      genderPlaceholder,
      dateOfBirthPlaceholder,
      phoneNumberPlaceholder;

UserDataProviderApiClient userdataApi = UserDataProviderApiClient();
  _EditAccountScreenState(this.userData);

  String phoneIsoCode;
  List<String> genderList = ['Male', 'Female', 'Others'];

  bool isSubmitting;
  @override
  void initState() {
    userbloc = BlocProvider.of<UserBloc>(context);
    firstNamePlaceholder = userData.firstName;
    lastNamePlaceholder = userData.lastName;
    emailplaceholder = userData.email;
    phoneNumberPlaceholder = userData.phoneNumber;
    dateOfBirthPlaceholder = userData.dateofbirth;
    genderPlaceholder = userData.gender;
    
    phoneIsoCode = '+91';
    isSubmitting = false;
    super.initState();
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            key: Key('email'),
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.grey,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.grey, //Colors.white,
              ),
              hintText: emailplaceholder,
              hintStyle: kHintTextStyle,
              enabled: false,
            ),
            autocorrect: false,
          ),
        ),
      ],
    );
  }


  Widget _buildFirstNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            key: Key('DisplayName'),
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.grey,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.grey, //Colors.white,
              ),
              hintText: firstNamePlaceholder,
              hintStyle: kHintTextStyle,
              enabled: true,
            ),
            autocorrect: false,
            onChanged: (value) {
              setState(() {
                firstNamePlaceholder = value;
              });
            },
            onSubmitted: (value) {
              setState(() {
                firstNamePlaceholder = value;
              });
            },
          ),
        ),
      ],
    );
  }
    Widget _buildlastNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            key: Key('DisplayName'),
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.grey,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.grey, //Colors.white,
              ),
              hintText: lastNamePlaceholder,
              hintStyle: kHintTextStyle,
              enabled: true,
            ),
            autocorrect: false,
            onChanged: (value) {
              setState(() {
                lastNamePlaceholder = value;
              });
            },
            onSubmitted: (value) {
              setState(() {
                lastNamePlaceholder = value;
              });
            },
          ),
        ),
      ],
    );
  }
  Widget _buildPhoneNumberField() {
    void onPhoneNumberChange(
        String number, String internationalizedPhoneNumber, String isoCode) {
      setState(() {
        phoneNumberPlaceholder = number;
        phoneIsoCode = isoCode;
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10.0),
        Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            height: 60.0,
            child: Container(
              margin: const EdgeInsets.only(left: 14.0, right: 14.0),
              alignment: Alignment.center,
              height: 50.0,
              child: InternationalPhoneInput(
                onPhoneNumberChange: onPhoneNumberChange,
                initialPhoneNumber: phoneNumberPlaceholder,
                initialSelection: phoneIsoCode,
                enabledCountries: ['+91'],
                hintText: "Phone Number",
              ),
            )),
      ],
    );
  }

  _prefixIcon(IconData iconData) {
    return Container(
        margin: const EdgeInsets.only(left: 14.0),
        alignment: Alignment.centerLeft,
        height: 60,
        child: Icon(
          iconData,
          color: Colors.grey,
        ));
  }

  Future<Null> _selectDate(BuildContext context) async {}

  Widget _buildGenderField() {
    Map<int, Widget> map = new Map();
    List<String> genderList = ['Male', 'Female', 'Others'];
    for (var key in genderList) {
      map.putIfAbsent(
          genderList.indexOf(key),
          () => Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width / 4,
              child: Text(
                "$key",
                style: TextStyle(color: Colors.black),
              )));
    }

    int selectedGenderIndex = genderList.indexOf(genderPlaceholder);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10.0),
          Container(
              alignment: Alignment.centerLeft,
              decoration: kBoxDecorationStyle,
              height: 60.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  CupertinoSegmentedControl(
                    onValueChanged: (value) {
                      print(value);
                      setState(() {
                        genderPlaceholder = genderList[value];
                        selectedGenderIndex = value;
                      });
                    },
                    groupValue:
                        selectedGenderIndex, //The current selected Index or key
                    selectedColor: Colors
                        .blue, //Color that applies to selecte key or index
                    children: map,
                    //The tabs which are assigned in the form of map
                  ),
                ],
              ))
        ]);
  }

  Widget _buildDateOfBirthPicker() {
    final df = new DateFormat('dd-MM-yyyy');
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10.0),
          Container(
              alignment: Alignment.centerLeft,
              decoration: kBoxDecorationStyle,
              height: 60.0,
              child: Container(
                  margin: const EdgeInsets.only(left: 1.0, right: 1.0),
                  alignment: Alignment.center,
                  height: 50.0,
                  child: SizedBox.expand(
                      child: RaisedButton(
                    onPressed: () async {
                      DateTime picked;
                      picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.parse(dateOfBirthPlaceholder),
                          firstDate: DateTime(1890, 8),
                          lastDate: DateTime.now());
                      if (picked != null &&
                          picked.toIso8601String() != dateOfBirthPlaceholder) {
                        setState(() {
                          print("up");
                          dateOfBirthPlaceholder = picked.toIso8601String();
                        });
                      }
                    },
                    child: DateTime.parse(dateOfBirthPlaceholder).day !=
                            DateTime.now().toUtc().day
                        ? Text(
                            df.format(DateTime.parse(dateOfBirthPlaceholder)))
                        : Text('Pick Your Date of birth'),
                    color: base_color_monochrome_1,
                  ))))
        ]);
  }

  void _onSubmit() async {
    setState(() {
      print(isSubmitting);
      isSubmitting = !isSubmitting;
    });
    print(firstNamePlaceholder);
    print(lastNamePlaceholder);
    print(genderPlaceholder);
    print(dateOfBirthPlaceholder);
    print(phoneNumberPlaceholder);
    print(phoneIsoCode);
    print(userData.uid);

    if (firstNamePlaceholder == null || phoneNumberPlaceholder == '') {
      PlatformAlertDialog(
        title: "Alert",
        content: "Fill all fields to submit",
        defaultActionText: Strings.ok,
      ).show(context);
    } else {
      Map<String, dynamic> userDetailsJson = {
        'firstName': firstNamePlaceholder,
        'lastName':lastNamePlaceholder,
        'phoneNumber': phoneNumberPlaceholder,
        'phoneIsoCode': phoneIsoCode,
        'gender': genderPlaceholder,
        'dateofbirth': dateOfBirthPlaceholder
      };
      var result = await userdataApi.updateuser(userData.uid, userDetailsJson);
      if (result != null) {
        if (result['status'] == 'success') {
          PlatformAlertDialog(
            title: "Calm Down ",
            content: "We just Updated the values",
            defaultActionText: Strings.ok,
          ).show(context).then((onValue) {
            setState(() {
              isSubmitting = !isSubmitting;
            });

            userbloc.add(UserFetch());
            Navigator.of(context).pop();
          });
        } else {
          PlatformAlertDialog(
            title: "Alert",
            content: "Error connecting to server",
            defaultActionText: Strings.ok,
          ).show(context);
        }
      } else {
        PlatformAlertDialog(
          title: "Alert",
          content: "Error connecting to server",
          defaultActionText: Strings.ok,
        ).show(context);
      }
    }
  }

  Widget _buildsubmitbtn(BuildContext context) {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () => _onSubmit(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Submit',
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

  @override
  Widget build(BuildContext context) {
    userbloc = BlocProvider.of<UserBloc>(context);
    return Scaffold(
      appBar: EditAccountTopBar(
          title: "Edit Your Details",
          child: null,
          onPressed: () => Navigator.of(context).pop()),
      backgroundColor: tertiary_color, //DashboardTheme.background,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: <Widget>[
              Container(
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(38),
                          ),
                        ),
                        child: Container(
                            height: MediaQuery.of(context).size.height *
                                (10.3 / 12),
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * .05,
                              vertical:
                                  MediaQuery.of(context).size.width * .05 * 2,
                            ),
                            child: LoadingOverlay(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  _buildEmailField(),
                                  SizedBox(height: 8),
                                  _buildFirstNameField(),
                                  SizedBox(height: 8),
                                  _buildlastNameField(),
                                  SizedBox(height: 8),
                                  _buildPhoneNumberField(),
                                  SizedBox(height: 8),
                                  _buildGenderField(),
                                  SizedBox(height: 8),
                                  _buildDateOfBirthPicker(),
                                  SizedBox(height: 24),
                                  _buildsubmitbtn(context),
                                ],
                              ),
                              progressIndicator: CircularProgressIndicator(),
                              isLoading: isSubmitting,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
