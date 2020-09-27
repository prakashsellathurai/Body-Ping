import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIndicator extends StatefulWidget {
  LoadingIndicator({Key key}) : super(key: key);

  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  @override
  void initState() {
    // TODO: implement initState
    _animationController = AnimationController(
                                    vsync: this,
                                    duration:
                                        const Duration(milliseconds: 1200));
    super.initState();
  }

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
                            child: SpinKitCubeGrid(
                                color: Color(0xFF4FC1A6),
                                size: 50.0,
                                controller: _animationController,)
                            // child: FlareActor("assets/flare/loading.flr",
                            //     alignment: Alignment.center,
                            //     fit: BoxFit.none,
                            //     animation: "active"),
                          ))),
                ),
                Text('Loading....')
              ],
            )));
  }
}
