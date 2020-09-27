import 'package:flutter/material.dart';
import 'package:gkfit/screens/dashboard/dashboard_theme.dart';
import 'package:flutter_dash/flutter_dash.dart';

class FitnessFilterWidget extends StatefulWidget {
  FitnessFilterWidget({Key key}) : super(key: key);

  @override
  _FitnessFilterWidgetState createState() => _FitnessFilterWidgetState();
}

class _FitnessFilterWidgetState extends State<FitnessFilterWidget> {
  int selectedSortByValue;
  int selectedOrder;
  @override
  void initState() {
    // TODO: implement initState
    selectedSortByValue = 0;
    selectedOrder = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            textDirection: TextDirection.ltr,
            children: [
              Icon(Icons.tune, color: DashboardTheme.nearlyDarkBlue),
              SizedBox(width: 15.0),
              Text(
                "Filters",
                style: Theme.of(context)
                    .textTheme
                    .headline
                    .apply(color: DashboardTheme.nearlyDarkBlue),
              )
            ],
          ),
          Container(
              padding: EdgeInsets.all(10),
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      "Sort By",
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .apply(color: DashboardTheme.nearlyBlack),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Radio(
                          value: 0,
                          groupValue: selectedSortByValue,
                          onChanged: (value) => _handleSortbyRadioValue(value),
                        ),
                        Text(
                          'Title',
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Radio(
                          value: 1,
                          groupValue: selectedSortByValue,
                          onChanged: (value) => _handleSortbyRadioValue(value),
                        ),
                        Text(
                          'Intensity',
                          style: new TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          (selectedSortByValue == 0) ? "Order" : "List from",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2
                              .apply(color: DashboardTheme.nearlyBlack),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Flex(
                          direction: Axis.horizontal,
                          children: <Widget>[
                            Dash(),
                          ],
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    )
                  ],
                ),
                (selectedSortByValue == 0)
                    ? Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Radio(
                                value: 0,
                                groupValue: selectedOrder,
                                onChanged: (value) =>
                                    _handleselectedOrderValue(value),
                              ),
                              Text(
                                'A to Z',
                                style: new TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Radio(
                                value: 1,
                                groupValue: selectedOrder,
                                onChanged: (value) =>
                                    _handleselectedOrderValue(value),
                              ),
                              Text(
                                'Z to A',
                                style: new TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Radio(
                                value: 0,
                                groupValue: selectedOrder,
                                onChanged: (value) =>
                                    _handleselectedOrderValue(value),
                              ),
                              Text(
                                'Easy',
                                style: new TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Radio(
                                value: 1,
                                groupValue: selectedOrder,
                                onChanged: (value) =>
                                    _handleselectedOrderValue(value),
                              ),
                              Text(
                                'Medium',
                                style: new TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Radio(
                                value: 2,
                                groupValue: selectedOrder,
                                onChanged: (value) =>
                                    _handleselectedOrderValue(value),
                              ),
                              Text(
                                'Pro',
                                style: new TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ],
                      )
              ])),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.80,
                    child: GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 20.0),
                        padding: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(100, 140, 255, 1.0),
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(100, 140, 255, 0.5),
                                blurRadius: 10.0,
                                offset: Offset(0.0, 5.0),
                              ),
                            ]),
                        child: Text(
                          'Filter',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
      
                      },
                    )),
              )
            ],
          )
        ],
      ),
    ));
  }

  void _handleSortbyRadioValue(value) {
    setState(() {
      selectedSortByValue = value;
    });
  }

  void _handleselectedOrderValue(value) {
    setState(() {
      selectedOrder = value;
    });
  }
}
