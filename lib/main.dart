import 'package:flutter/services.dart';
import 'package:intercom_flutter/intercom_flutter.dart';

import './widgets/auth/auth_widget_builder.dart';
import './widgets/exceptions/email_link_error_presenter.dart';
import './widgets/auth/auth_widget.dart';
import './services/auth_service.dart';
import './services/auth_service_adapter.dart';
import './services/firebase_email_link_handler.dart';
import './services/email_secure_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // Fix for: Unhandled Exception: ServicesBinding.defaultBinaryMessenger was accessed before the binding was initialized.
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIOverlays ([SystemUiOverlay.bottom]);
await Intercom.initialize('rv4ydr2y', iosApiKey: 'ios_sdk-152bd9bbc8dc994be0b581e706b97a7bfbd7f3cd', androidApiKey: 'android_sdk-00787217d80052b3eee2d51235c22e803a521dce');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
    final AuthServiceType initialAuthServiceType = AuthServiceType.firebase;
  // [initialAuthServiceType] is made configurable for testing

  @override
  Widget build(BuildContext context) {
    // MultiProvider for top-level services that can be created right away
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthServiceAdapter(
            initialAuthServiceType: initialAuthServiceType,
          ),
          dispose: (_, AuthService authService) => authService.dispose(),
        ),
        Provider<EmailSecureStore>(
          create: (_) => EmailSecureStore(
            flutterSecureStorage: FlutterSecureStorage(),
          ),
        ),
        ProxyProvider2<AuthService, EmailSecureStore, FirebaseEmailLinkHandler>(
          update: (_, AuthService authService, EmailSecureStore storage, __) =>
              FirebaseEmailLinkHandler.createAndConfigure(
            auth: authService,
            userCredentialsStorage: storage,
          ),
          dispose: (_, linkHandler) => linkHandler.dispose(),
        ),
      ],
      child: AuthWidgetBuilder(
          builder: (BuildContext context, AsyncSnapshot<User> userSnapshot) {
        return MaterialApp(
          theme: ThemeData(primarySwatch: Colors.indigo),
          home: EmailLinkErrorPresenter.create(
            context,
            child: AuthWidget(userSnapshot: userSnapshot),
          ),
        );
      }),
    );
  }
}
