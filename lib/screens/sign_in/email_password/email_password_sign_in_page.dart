import 'package:avatar_glow/avatar_glow.dart';
import 'package:gkfit/widgets/exceptions/platform_alert_dialog.dart';
import 'package:gkfit/widgets/exceptions/platform_exception_alert_dialog.dart';
import 'package:gkfit/widgets/ui/login_page_back_button.dart';

import './email_password_sign_in_model.dart';
import './../../../constants/strings.dart';
import './../../../services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import './../../../constants/colors.dart';

final kHintTextStyle = TextStyle(
  color:  Colors.grey ,//Colors.white54,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Color(0xFF253840),
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: base_color_monochrome_1,//Color(0xFF41B4BC),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);



class EmailPasswordSignInPage extends StatefulWidget {
  const EmailPasswordSignInPage._(
      {Key key, @required this.model, this.formType ,this.onSignedIn})
      : super(key: key);
  final EmailPasswordSignInModel model;
  final EmailPasswordSignInFormType formType;
  final VoidCallback onSignedIn;

  static Future<void> show(BuildContext context,
  EmailPasswordSignInFormType formType,
      {VoidCallback onSignedIn}) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        // fullscreenDialog: true,
        builder: (_) =>
            EmailPasswordSignInPage.create(context,formType, onSignedIn: onSignedIn),
      ),
    );
  }

  static Widget create(BuildContext context, EmailPasswordSignInFormType formType, {VoidCallback onSignedIn}) {
    final AuthService auth = Provider.of<AuthService>(context, listen: false);
    return ChangeNotifierProvider<EmailPasswordSignInModel>(
      create: (_) => EmailPasswordSignInModel(auth: auth,formType: formType),
      child: Consumer<EmailPasswordSignInModel>(
        builder: (_, EmailPasswordSignInModel model, __) =>
            EmailPasswordSignInPage._(model: model, onSignedIn: onSignedIn),
      ),
    );
  }

  @override
  _EmailPasswordSignInPageState createState() =>
      _EmailPasswordSignInPageState();
}

class _EmailPasswordSignInPageState extends State<EmailPasswordSignInPage> {
  final FocusScopeNode _node = FocusScopeNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  EmailPasswordSignInModel get model => widget.model;

  @override
  void dispose() {
    _node.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSignInError(
      EmailPasswordSignInModel model, PlatformException exception) {
    PlatformExceptionAlertDialog(
      title: model.errorAlertTitle,
      exception: exception,
    ).show(context);
  }

  Future<void> _submit() async {
    try {
      final bool success = await model.submit();
      if (success) {
        if (model.formType == EmailPasswordSignInFormType.forgotPassword) {
          await PlatformAlertDialog(
            title: Strings.resetLinkSentTitle,
            content: Strings.resetLinkSentMessage,
            defaultActionText: Strings.ok,
          ).show(context);
        } else {
          if (widget.onSignedIn != null) {
            widget.onSignedIn();
          }
        }
      }
    } on PlatformException catch (e) {
      _showSignInError(model, e);
    }
  }

  void _emailEditingComplete() {
    if (model.canSubmitEmail) {
      _node.nextFocus();
    }
  }

  void _passwordEditingComplete() {
    if (!model.canSubmitEmail) {
      _node.previousFocus();
      return;
    }
    _submit();
  }

  void _updateFormType(EmailPasswordSignInFormType formType) {
    model.updateFormType(formType);
    _emailController.clear();
    _passwordController.clear();
  }

  Widget _buildEmailField() {

     return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            key: Key('email'),
            controller: _emailController,
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
                color: Colors.grey,//Colors.white,
              ),
              hintText: 'Enter your Email',
              hintStyle: kHintTextStyle,
              enabled: !model.isLoading,
              errorText: model.emailErrorText,
            ),
             autocorrect: false,
              onChanged: model.updateEmail,
              onEditingComplete: _emailEditingComplete,
              inputFormatters: <TextInputFormatter>[
                model.emailInputFormatter,
              ],
          ),
        ),
      ],
    );
  }
  Widget _buildLogo() {

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
              backgroundColor: Colors.grey[100],
              radius: 50.0,
              child: Image(
                width: MediaQuery.of(context).size.width * scaleFactor,
                height: MediaQuery.of(context).size.height * scaleFactor,
                image: AssetImage('assets/images/logo.png'),
                fit: BoxFit.scaleDown,
              ),
            )),
        endRadius: 90);
  }
  Widget _buildPasswordField() {
     return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            key: Key('password'),
            controller: _passwordController,
            obscureText: true,
            style: TextStyle(
              color: Colors.grey,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.grey,
              ),
              hintText: model.passwordLabelText,
              hintStyle: kHintTextStyle,
              errorText: model.passwordErrorText,
              enabled: !model.isLoading,
            ),
            autocorrect: false,
            textInputAction: TextInputAction.done,
            keyboardAppearance: Brightness.light,
            onChanged: model.updatePassword,
            onEditingComplete: _passwordEditingComplete,
          ),
        ),
      ],
    );
  }
  Widget _buildSignInBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        key: Key('primary-button'),
        elevation: 5.0,
        onPressed: model.isLoading ? null : _submit,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          model.primaryButtonText,
          style: TextStyle(
            color: Color(0xFF253840),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
  Widget _buildContent() {
    return  Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 8.0),
          _buildEmailField(),
          if (model.formType !=
              EmailPasswordSignInFormType.forgotPassword) ...<Widget>[
            SizedBox(height: 8.0),
            _buildPasswordField(),
          ],
          SizedBox(height: 8.0),
          _buildSignInBtn(),
          SizedBox(height: 8.0),
          FlatButton(
            key: Key('secondary-button'),
            child: Text(model.secondaryButtonText),
            onPressed: model.isLoading
                ? null
                : () => _updateFormType(model.secondaryActionFormType),
          ),
          if (model.formType == EmailPasswordSignInFormType.signIn)
            FlatButton(
              key: Key('tertiary-button'),
              child: Text(Strings.forgotPasswordQuestion),
              onPressed: model.isLoading
                  ? null
                  : () => _updateFormType(
                      EmailPasswordSignInFormType.forgotPassword),
            ),
        ],
     
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  
      TopBar(title: model.title,
      onPressed:() => Navigator.pop(context), child: null,),
      backgroundColor:  base_color_monochrome_1,  
      body:  AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      base_color_monochrome_1,
                      base_color_monochrome_2,
                      base_color_monochrome_3,
                      base_color_monochrome_4,
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 40.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                       _buildLogo(),
                     _buildContent()
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
