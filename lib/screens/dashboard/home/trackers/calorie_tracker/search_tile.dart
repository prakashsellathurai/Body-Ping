import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gkfit/model/trackers/Nutrition_database_model.dart';

import '../../../dashboard_theme.dart';

class SearchTile extends StatefulWidget {
  final NutritionDatabaseModel meal_data;
  final ValueChanged<bool> isSelected;
  final bool selectionDefault;
  SearchTile({this.meal_data,this.selectionDefault,this.isSelected});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SearchTileState();
  }
}

class SearchTileState extends State<SearchTile> {
  bool isSelected;
  @override
  void initState() {
     isSelected= widget.selectionDefault;
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                widget.meal_data.name,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: DashboardTheme.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  letterSpacing: 0.5,
                  color: DashboardTheme.lightText,
                ),
              ),
            ),
            (!isSelected)
                ? InkWell(
                    highlightColor: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    onTap: () {
                      setState(() {
                        
                        isSelected = !isSelected;
                        widget.isSelected(isSelected);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            height: 38,
                            width: 26,
                            child: Icon(
                              Icons.add,
                              color: DashboardTheme.darkText,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : InkWell(
                    highlightColor: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    onTap: () {
                      setState(() {
                        
                        isSelected = !isSelected;
                        widget.isSelected(isSelected);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            height: 38,
                            width: 26,
                            child: Icon(
                              Icons.delete,
                              color: DashboardTheme.darkText,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
