import 'dart:convert';

import 'package:customer_app/constants/constants.dart';
import 'package:customer_app/widgets/error/no_internet.dart';
import 'package:customer_app/widgets/loading/loadingIndicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutFounderScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AboutFounderScreenState();
}

class AboutFounderScreenState extends State<AboutFounderScreen> {
  int _index;

  @override
  void initState() {
    // TODO: implement initState
    _index = 2;
    super.initState();
  }
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
      body: LayoutBuilder(
        builder: (context, _) => Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.chevron_left,
                      color: Colors.grey,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Container(
                child: 
                IndexedStack(index: _index, children: <Widget>[
              DraggableScrollableSheet(
                initialChildSize: .95,
                minChildSize: .95,
                builder: (context, controller) => Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      topLeft: Radius.circular(25),
                    ),
                  ),
                  child: Container(
                    child: WebView(
                      initialUrl: Constants.aboutFounderUrl,
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebResourceError: (err) {
                        print(err);
                        setState(() {
                          _index = 1;
                        });
                      },
                      onPageFinished: (finished) {
                        setState(() {
                          _index = 0;
                        });
                      },
                    ),
                  ),
                ),
              ),
              NoInternet(),
              LoadingIndicator()
            ])),
          ],
        ),
      ),
    ));
  }
}
