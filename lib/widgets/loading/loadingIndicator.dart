import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * (1 / 3),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * (1 / 3),
                  child: Container(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Center(
                            child: FlareActor("assets/flare/loading.flr",
                                alignment: Alignment.center,
                                fit: BoxFit.none,
                                animation: "active"),
                          ))),
                ),
                Text('Loading....')
              ],
            )));
  }
}
