import './../../widgets/exceptions/platform_alert_dialog.dart';
import 'package:gkfit/constants/colors.dart';
import 'package:gkfit/constants/strings.dart';
import 'package:gkfit/model/userDataModel.dart';
import 'package:gkfit/provider/userDataProviderApiClient.dart';
import 'package:gkfit/screens/on_boarding/user_submit_loading_page.dart';
import 'package:gkfit/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'package:intl/intl.dart';

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

class OnBoardingFormPage extends StatefulWidget {
  User user;
  OnBoardingFormPage({this.user});
  @override
  State<StatefulWidget> createState() {
    return UserDetailsFormPageState(this.user);
  }
}

class UserDetailsFormPageState extends State<OnBoardingFormPage>
    with TickerProviderStateMixin {
  User user;
  String gender;
  int selectedGenderIndex;
  DateTime selectedDate;
  String displayNameField;
  String phoneNumber;
  String phoneIsoCode;

  UserDataProviderApiClient userdataprovider = new UserDataProviderApiClient();
  AnimationController _submitAnimationController;
  UserDetailsFormPageState(this.user);
  @override
  void initState() {
    super.initState();
    _submitAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _submitAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {}
    });
    setState(() {
      gender = 'Male';
      selectedGenderIndex = 0;
      selectedDate = DateTime.now();
      phoneNumber = '';
      phoneIsoCode = '+91';
    });
  }

  @override
  void dispose() {
    _submitAnimationController.dispose();
    super.dispose();
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
              hintText: user.email,
              hintStyle: kHintTextStyle,
              enabled: false,
            ),
            autocorrect: false,
          ),
        ),
      ],
    );
  }

  Widget _buildDisplayNameField() {
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
                color: Colors.grey,
              ),
              hintText: "Enter your name",
              hintStyle: kHintTextStyle,
              enabled: true,
            ),
            autocorrect: false,
            onChanged: (value) {
              setState(() {
                displayNameField = value;
              });
            },
            onSubmitted: (value) {
              setState(() {
                displayNameField = value;
              });
            },
          ),
        ),
      ],
    );
  }

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    print((phoneNumber == null || phoneNumber == ''));
    print(phoneNumber == '');
    print(phoneNumber);
    setState(() {
      phoneNumber = number;
      phoneIsoCode = isoCode;
    });
  }

  Widget _buildPhoneNumberField() {
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
                initialPhoneNumber: phoneNumber,
                initialSelection: phoneIsoCode,
                enabledCountries: ['+91'],
                hintText: "Phone Number",
              ),
            )
            ),
      ],
    );
  }

  Widget _buildDateOfBirthPicker() {
    Future<Null> _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(1890, 8),
          lastDate: DateTime.now());
      if (picked != null && picked != selectedDate)
        setState(() {
          selectedDate = picked;
        });
    }

    final df = new DateFormat('dd-MM-yyyy');

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10.0),
          Container(
              alignment: Alignment.centerLeft,
              decoration: kBoxDecorationStyle,
              // height: 60.0,
              child: Container(
                  margin: const EdgeInsets.only(left: 1.0, right: 1.0),
                  alignment: Alignment.center,
                  height: 50.0,
                  child: SizedBox.expand(
                      child: RaisedButton(
                    onPressed: () => _selectDate(context),
                    child: selectedDate.day != DateTime.now().toUtc().day
                        ? Text(df.format(selectedDate))
                        : Text('Pick Your Date of birth'),
                    color: base_color_monochrome_1,
                  ))))
        ]);
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

  Widget _buildGenderField() {
    Map<int, Widget> map = new Map();
    List<Widget> childWidgets;
    int selectedIndex = 0;
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
                        gender = genderList[value];
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



  Widget _buildsubmitbtn(BuildContext context) {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () async {
        print(displayNameField);
        print(gender);
        print(selectedDate);
        print(phoneNumber == '');
        print(phoneIsoCode);
        print(user.uid);

        if (displayNameField == null || phoneNumber == '') {
          PlatformAlertDialog(
            title: "Alert",
            content: "Fill all fields to submit",
            defaultActionText: Strings.ok,
          ).show(context);
        } else {
          String uid = user.uid;
          Map<String, dynamic> userDetailsResponseJson = {
            'email': user.email,
            'uid': uid,
            'photoUrl': user.photoUrl,
            'displayName': displayNameField,
            'phoneNumber': phoneNumber,
            'phoneIsoCode': phoneIsoCode,
            'gender': gender,
            'dateofbirth': selectedDate.toIso8601String(),
            'currentPlan': 'free'
          };
          var userData = UserDataModel.fromJson(userDetailsResponseJson);

          Navigator.push(
              context,
              MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) =>
                      UserSubmitLoadingPage(uid, userData.toJson)));
        }
      },
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
    // TODO: implement build
    return Scaffold(
      appBar: UserDetailsTopBar(
        title: "Tell Us About You",
        onPressed: () => Navigator.pop(context),
        topbarHeight: 50,
        child: null,
      ),
      backgroundColor: secondary_color,
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
                          elevation: 20,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(38),
                              topRight: Radius.circular(38),
                            ),
                          ),
                          child: Container(
                              height: MediaQuery.of(context).size.height - 50,
                              // (11 / 12),
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * .05,
                                vertical:
                                    MediaQuery.of(context).size.width * .05,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  _buildEmailField(),
                                  SizedBox(height: 8),
                                  _buildDisplayNameField(),
                                  SizedBox(height: 8),
                                  _buildPhoneNumberField(),
                                  SizedBox(height: 8),
                                  _buildGenderField(),
                                  SizedBox(height: 8),
                                  _buildDateOfBirthPicker(),
                                  SizedBox(height: 24),
                                  _buildsubmitbtn(context),
                                ],
                              )))
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

class UserDetailsTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget child;
  final Function onPressed;
  final Function onTitleTapped;

  @override
  final Size preferredSize;

  double topbarHeight;

  UserDetailsTopBar(
      {@required this.title,
      @required this.child,
      @required this.onPressed,
      this.onTitleTapped,
      this.topbarHeight})
      : preferredSize = Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Container(
              height: topbarHeight,
              child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.black54,
                    ),
                  )))
        ],
      ),
    );
  }
}
