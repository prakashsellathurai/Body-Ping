import 'package:flutter/material.dart';

class NextStep extends StatelessWidget {
  final String image, title;
  final int seconds;

  NextStep({
    @required this.image,
    @required this.title,
    @required this.seconds,
  });

  @override
  Widget build(BuildContext context) {
    // return Row(
    //   children: <Widget>[
    //     Container(
    //       height: 60.0,
    //       width: 60.0,
    //       margin: EdgeInsets.only(
    //         right: 20.0,
    //         bottom: 20.0,
    //       ),
    //       decoration: BoxDecoration(
    //         image: DecorationImage(
    //           image: AssetImage(
    //             this.image,
    //           ),
    //           fit: BoxFit.cover,
    //         ),
    //         borderRadius: BorderRadius.circular(15.0),
    //       ),
    //     ),
    //     Container(
    //       height: 65.0,
    //       child:
    // Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: <Widget>[
    //           Text(
    //             this.title,
    //             style: TextStyle(
    //               fontSize: 16.0,
    //               color: Colors.black87,
    //             ),
    //           ),
    //           Text(
    //             '${this.seconds} sec',
    //             style: TextStyle(
    //               fontSize: 14.0,
    //               color: Colors.blueGrey[200],
    //             ),
    //           )
    //         ],
    //       ),
    //     ),
    //   ],
    // );

    return Stack(children: <Widget>[
      new Padding(
        padding: const EdgeInsets.only(left: 50.0),
        child: new Card(
          margin: new EdgeInsets.all(20.0),
            color: Colors.transparent,
          elevation: 0,
          child: new Container(
            width: double.infinity,
            height: 20.0,
            color: Colors.transparent,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  this.title,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                ),
                Text("  -  "),
                Text(
                  '${this.seconds} sec',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.blueGrey[200],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      new Positioned(
        top: 0.0,
        bottom: 0.0,
        left: 35.0,
        child: new Container(
          height: double.infinity,
          width: 1.0,
          color: Colors.blue,
        ),
      ),
      new Positioned(
        top: 10.0,
        left: 15.0,
        child: new Container(
          height: 40.0,
          width: 40.0,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: new Container(
            margin: new EdgeInsets.all(5.0),
            height: 30.0,
            width: 30.0,
            decoration: new BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  this.image,
                ),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ),
      )
    ]);
  }
}
