import 'package:gkfit/constants/colors.dart';
import 'package:flutter/material.dart';


ShapeBorder kBackButtonShape = BeveledRectangleBorder(
  borderRadius: BorderRadius.only(
    bottomRight: Radius.circular(40),
  ),
);

Widget kBackBtn = Icon(
  Icons.arrow_back,
  color: Colors.black54,
);

class EditAccountTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget child;
  final Function onPressed;
  final Function onTitleTapped;

  @override
  final Size preferredSize;

  EditAccountTopBar(
      {@required this.title,
      @required this.child,
      @required this.onPressed,
      this.onTitleTapped})
      : preferredSize = Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              FlatButton(
                // height: 50,
                // minWidth: 50,
                // elevation: 10,
                color: tertiary_color,
                // shape: kBackButtonShape,
                onPressed: onPressed,
                child: kBackBtn,
              ),
              InkWell(
                onTap: onTitleTapped,
                child: Container(
                  width: MediaQuery.of(context).size.width * (1 / 1.5),
                  height: MediaQuery.of(context).size.height / 16,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
