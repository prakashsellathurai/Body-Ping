import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gkfit/model/trackers/Nutrition_database_model.dart';
import '../../../dashboard_theme.dart';

class AddQuantityToFoodTile extends StatefulWidget {
  NutritionDatabaseModel meal_data;
  double quantity;
  int count;
  int index;
  ValueChanged<int> currentCount;
  AddQuantityToFoodTile(
      {Key key,
      this.index,
      this.meal_data,
      this.quantity,
      this.count,
      this.currentCount})
      : super(key: key);

  @override
  _AddQuantityToFoodTileState createState() => _AddQuantityToFoodTileState();
}

class _AddQuantityToFoodTileState extends State<AddQuantityToFoodTile> {
  int currentCount;
  @override
  void initState() {
    // TODO: implement initState
    currentCount = widget.count;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Row(children: <Widget>[
              Text('${(widget.index + 1).toString()} .'),
              Expanded(
                child: Text(
                  '\n' +
                      widget.meal_data.name +
                      '\n\n ${(currentCount * widget.meal_data.total_calories).toString()} calories per ${(widget.quantity.toInt()*currentCount).toString()} grams',
                  textAlign: TextAlign.left,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentCount = currentCount + 1;
                    widget.currentCount(currentCount);
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
                  '${currentCount}',
                  style: DashboardTheme.textTheme.headline2,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentCount = (currentCount - 1) <= 0 ? 0: (currentCount - 1);
                    widget.currentCount(currentCount);
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
            ])));
  }
}
