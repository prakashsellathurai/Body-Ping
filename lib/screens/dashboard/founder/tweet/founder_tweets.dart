import 'package:gkfit/constants/constants.dart';
import 'package:gkfit/screens/dashboard/dashboard_theme.dart';
import 'package:gkfit/widgets/error/no_internet.dart';
import 'package:gkfit/widgets/loading/loadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
class Foundertweets extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FoundertweetsState();
  }

}
class FoundertweetsState extends State<Foundertweets> {
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
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(45),
          bottomRight: Radius.circular(45),
        )),
        title: Text("Latest Tweets"),
        centerTitle: true,
      ),
      backgroundColor: DashboardTheme.background,
      body: IndexedStack(
        index: _index,
        children: <Widget>[
        Container(
        child: WebView(
          initialUrl: Constants.foundertweetsUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebResourceError: (err) {
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
      NoInternet(),
      LoadingIndicator()
        ],
      )
      
 
    );
  }
}
