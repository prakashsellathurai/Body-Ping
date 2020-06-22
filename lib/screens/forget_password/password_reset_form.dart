import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gkfit/bloc/authentication/authentication_bloc.dart';
import 'package:gkfit/bloc/forget_password/bloc.dart';
import 'package:gkfit/screens/forget_password/forget_password_submit_button.dart';
import 'package:gkfit/widgets/exceptions/platform_alert_dialog.dart';

class PasswordResetForm extends StatefulWidget {
  State<PasswordResetForm> createState() => _PasswordResetFormState();
}

class _PasswordResetFormState extends State<PasswordResetForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  ForgetPasswordBloc _forgetPasswordBloc;

  bool get isPopulated => _emailController.text.isNotEmpty;

  bool isRegisterButtonEnabled(ForgetPasswordState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _forgetPasswordBloc = BlocProvider.of<ForgetPasswordBloc>(context);
    _emailController.addListener(_onEmailChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgetPasswordBloc, ForgetPasswordState>(
      listener: (context, state) {
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Sending Email...'),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          // BlocProvider.of<AuthenticationBloc>(context)
          //     .add(AuthenticationLoggedIn());
          Scaffold.of(context)..hideCurrentSnackBar();
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                  title: Center(child: Text("Email Sent")),
                  content: FlatButton(
                      child: Text("Go Back"),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.black)),
                      onPressed: () => {Navigator.of(context).pop()})));
        }
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Email Sent Failure'),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: BlocBuilder<ForgetPasswordBloc, ForgetPasswordState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(2),
            child: Form(
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    autovalidate: true,
                    validator: (_) {
                      return !state.isEmailValid ? 'Invalid Email' : null;
                    },
                  ),
                  ForgetPasswordSubmitButton(
                    onPressed: isRegisterButtonEnabled(state)
                        ? _onFormSubmitted
                        : null,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _forgetPasswordBloc.add(
      RegisterEmailChanged(email: _emailController.text),
    );
  }

  void _onFormSubmitted() {
    _forgetPasswordBloc.add(
      RegisterSubmitted(
        email: _emailController.text,
      ),
    );
  }
}
