import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/widgets.dart';
class LoadingIndicator extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
                child: new FlareActor("assets/flare/loading.flr",
                    alignment: Alignment.center,
                    fit: BoxFit.scaleDown,
                    animation: "active"),
              );
  }

}