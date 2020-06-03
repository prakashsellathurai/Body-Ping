import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gkfit/model/trackers/Nutrition_database_model.dart';
import '../../../dashboard_theme.dart';

class AddQuantityToFoodTile extends StatefulWidget {
  NutritionDatabaseModel meal_data;
  double quantity;
  double count;
  int index;
  ValueChanged<double> currentQuantity;
  AddQuantityToFoodTile(
      {Key key,
      this.index,
      this.meal_data,
      this.quantity,
      this.count,
      this.currentQuantity})
      : super(key: key);

  @override
  _AddQuantityToFoodTileState createState() => _AddQuantityToFoodTileState();
}

class _AddQuantityToFoodTileState extends State<AddQuantityToFoodTile> {
  double currentquantity;
  @override
  void initState() {
    // TODO: implement initState
    currentquantity = widget.quantity;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: 
            Row(children: <Widget>[
              Expanded(
                child: Text(
                  '\n' +
                      '${(widget.index + 1).toString()} . ' +
                      widget.meal_data.name,
                      style: TextStyle(

                      ),
                  textAlign: TextAlign.left,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentquantity = currentquantity + 100;
                    widget.currentQuantity(currentquantity);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: DashboardTheme.nearlyWhite,
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: DashboardTheme.nearlyDarkBlue.withOpacity(0.4),
                          offset: const Offset(4.0, 4.0),
                          blurRadius: 8.0),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Icon(
                      Icons.add,
                      color: DashboardTheme.nearlyDarkBlue,
                      size: 15,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  '${currentquantity} g',
                  style: DashboardTheme.textTheme.headline2,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentquantity = currentquantity - 100;
                    currentquantity = (currentquantity <= 0)
                        ? double.parse('0')
                        : currentquantity;
                    widget.currentQuantity(currentquantity);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: DashboardTheme.nearlyWhite,
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: DashboardTheme.nearlyDarkBlue.withOpacity(0.4),
                          offset: const Offset(4.0, 4.0),
                          blurRadius: 8.0),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Icon(
                      Icons.remove,
                      color: DashboardTheme.nearlyDarkBlue,
                      size: 15,
                    ),
                  ),
                ),
              ),
            ]
            
            )));
  }
}
