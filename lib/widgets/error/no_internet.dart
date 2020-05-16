import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/widgets.dart';

class NoInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
                child: new FlareActor("assets/flare/no_internet.flr",
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    animation: "net"),
              );
  }

}