import 'package:flutter/material.dart';
import 'package:gkfit/model/trackers/Nutrition_database_model.dart';
import 'package:gkfit/repository/nutrition_search_repository.dart';
import 'package:gkfit/screens/dashboard/home/trackers/calorie_tracker/search_tile.dart';
import '../../../dashboard_theme.dart';
import './addQuantityTile.dart';

class AddMealScreen extends StatefulWidget {
  String meal_title;
  AddMealScreen({this.meal_title});
  @override
  _AddMealScreenState createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  TextEditingController editingController = TextEditingController();
  NutritionSearchRepository _nutritionSearchRepository =
      NutritionSearchRepository();

  var items = List<NutritionDatabaseModel>();
  var selectedItems = List<NutritionDatabaseModel>();
  var selectedItemsQuantity = List<int>();
  bool showDone = false;
  @override
  void initState() {
    // items.addAll(duplicateItems);
    super.initState();
  }

  void filterSearchResults(String query) async {
    if (query.isNotEmpty || query == '') {
      List<NutritionDatabaseModel> queryResults =
          await _nutritionSearchRepository.searchByName(query);
      setState(() {
        items.clear();
        items.addAll(queryResults);
      });
      return;
    } else {
      setState(() {
        items.clear();
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: DashboardTheme.nearlyWhite,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(45),
          bottomRight: Radius.circular(45),
        )),
        actions: <Widget>[
          Center(
              child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: FlatButton(
                      color: DashboardTheme.nearlyWhite,
                      onPressed: () {
                        print('done');
                      },
                      child: Text(
                        'done',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: Colors.black),
                      ))))
        ],
        centerTitle: true,
        title: Text(
          'Add ' + widget.meal_title,
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.black),
        ),
      ),
      backgroundColor: DashboardTheme.background,
      body: Container(
         height: selectedItems.length > 0 ? (selectedItems.length * 200).toDouble() : MediaQuery.of(context).size.height,
          child: DraggableScrollableSheet(
            expand: true,
            initialChildSize: .95,
            minChildSize: .95,
            builder: (context, controller) => Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
              Container(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    filterSearchResults(value);
                  },
                  controller: editingController,
                  decoration: InputDecoration(
                      labelText: "Search",
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.0)))),
                ),
              )),
              Container(
                  child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return SearchTile(
                      meal_data: items[index],
                      selectionDefault: false,
                      isSelected: (bool value) {
                        setState(() {
                          if (value) {
                            selectedItems.add(items[index]);
                            selectedItemsQuantity.add(1);
                          } else {
                            selectedItemsQuantity
                                .removeAt(selectedItems.indexOf(items[index]));
                            selectedItems.remove(items[index]);
                          }
                        });
                      });
                },
              )),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  "Selected Meal list",
                  style: DashboardTheme.textTheme.headline5,
                ),
              ),
              Container(
                  child: ListView.builder(
                controller: controller,
                shrinkWrap: true,
                itemCount: selectedItems.length,
                itemBuilder: (context, index) {
                  return AddQuantityToFoodTile(
                      index: index,
                      meal_data: selectedItems[index],
                      quantity: selectedItems[index].quantity_in_grams,
                      count: 1,
                      currentCount: (int currentCount) {
                        setState(() {
                          if (currentCount == 0) {
                            selectedItems.remove(selectedItems[index]);
                            selectedItemsQuantity
                                .remove(selectedItemsQuantity[index]);
                          } else {
                            selectedItemsQuantity[index] = currentCount;
                          }

                          if (selectedItems.length > 0) {
                            showDone = true;
                          } else {
                            selectedItems = List<NutritionDatabaseModel>();
                            selectedItemsQuantity = List<int>();
                            showDone = false;
                          }
                        });
                        print((selectedItems[index].total_calories));

                        // print(selectedItems);
                        // print(selectedItemsQuantity);
                      });
                },
              )),
              SizedBox(
                height:AppBar().preferredSize.height + 200
              ),
            ]),
          )),
    );
  }
}
