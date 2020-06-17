import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gkfit/bloc/trackers/calorieIntake/CalorieIntakeBloc.dart';
import 'package:gkfit/bloc/trackers/calorieIntake/CalorieIntakeEvent.dart';
import 'package:gkfit/model/trackers/Nutrition_database_model.dart';
import 'package:gkfit/repository/nutrition_search_repository.dart';
import 'package:gkfit/screens/dashboard/home/trackers/calorie_tracker/search_tile.dart';
import '../../../dashboard_theme.dart';
import './addQuantityTile.dart';
import 'dart:developer' as developer;

class AddMealScreen extends StatefulWidget {
  String meal_title;
  List<NutritionDatabaseModel> mealListFromDatabase;
  String mealSelector;
bool isTyping;
  List<double> mealQuantityList;
  AddMealScreen(
      {this.meal_title,
      this.mealListFromDatabase,
      this.mealSelector,
      this.mealQuantityList});
  @override
  _AddMealScreenState createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  TextEditingController editingController = TextEditingController();
  NutritionSearchRepository _nutritionSearchRepository =
      NutritionSearchRepository();

  var items = List<NutritionDatabaseModel>();
  var selectedItems = List<NutritionDatabaseModel>();
  var selectedItemsQuantity = List<double>();
  String mealSelector;
  bool showDone = false;
  @override
  void initState() {
    mealSelector = widget.mealSelector;
    selectedItems.addAll(widget.mealListFromDatabase);
    selectedItemsQuantity.addAll(widget.mealQuantityList);
    super.initState();
  }

  void filterSearchResults(String query) async {
    if (query.isNotEmpty) {
      setState(() {
        widget.isTyping = true;
      });
      List<NutritionDatabaseModel> queryResults =
          await _nutritionSearchRepository.searchByName(query);
      setState(() {
        items.clear();
        items.addAll(queryResults);
      });
      return;
    } else {
      setState(() {
          widget.isTyping = false;
        items.clear();
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    CalorieIntakeBloc calorieIntakeBloc =
        BlocProvider.of<CalorieIntakeBloc>(context);
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
                          List<double> calories_list = [];
                          double totalCalories = 0;
                          for (var item in selectedItems) {
                            int index = selectedItems.indexOf(item);
                            double multipliedCalorie = item.total_calories *
                                selectedItemsQuantity[index];
                            calories_list.insert(index, multipliedCalorie);
                            totalCalories = totalCalories + multipliedCalorie;
                          }

                          if (mealSelector == 'breakfast') {
                            calorieIntakeBloc
                              ..add(AddBreakFastEvent(
                                  meallist: selectedItems,
                                  mealListQuantity: selectedItemsQuantity,
                                  totalCalories: totalCalories,
                                  calories_list: calories_list));
                            calorieIntakeBloc
                              ..add(UpdateBreakfastModelIndatabaseEvent());
                          } else if (mealSelector == 'morningSnack') {

                            calorieIntakeBloc
                              ..add(AddMorningSnack(
                                  meallist: selectedItems,
                                  mealListQuantity: selectedItemsQuantity,
                                  totalCalories: totalCalories,
                                  calories_list: calories_list))
                              ..add(UpdateMorningSnackModelIndatabaseEvent());
                          } else if (mealSelector == 'lunch') {
                            calorieIntakeBloc
                              ..add(AddLunch(
                                  meallist: selectedItems,
                                  mealListQuantity: selectedItemsQuantity,
                                  totalCalories: totalCalories,
                                  calories_list: calories_list))
                              ..add(UpdateLunchlModelIndatabaseEvent());
                          } else if (mealSelector == 'eveningSnack') {
                            calorieIntakeBloc
                              ..add(AddEveningSnack(
                                  meallist: selectedItems,
                                  mealListQuantity: selectedItemsQuantity,
                                  totalCalories: totalCalories,
                                  calories_list: calories_list))
                              ..add(UpdateEveneingMealModelIndatabaseEvent());
                          } else if (mealSelector == 'dinner') {
                            calorieIntakeBloc
                              ..add(AddDinner(
                                  meallist: selectedItems,
                                  mealListQuantity: selectedItemsQuantity,
                                  totalCalories: totalCalories,
                                  calories_list: calories_list))
                              ..add(UpdateDinnerModelIndatabaseEvent());
                          }
                          // calorieIntakeBloc
                          //   ..add(FetchEntiredayMealModelEvent());
                          Navigator.of(context).pop();
                          return;
                        },
                        child: 
                        
                        // Text(
                        //   'done',
                        //   style: Theme.of(context)
                        //       .textTheme
                        //       .headline6
                        //       .copyWith(color: Colors.black),
                        // )
                        Icon(Icons.done)
                        
                        )))
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
        body: Stack(
          children: <Widget>[
            DraggableScrollableSheet(
              expand: true,
              initialChildSize: .95,
              minChildSize: .95,
              builder: (context, controller) =>
                  Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                Center(
                  child: Text(
                    "Selected Meal list",
                    style: DashboardTheme.textTheme.headline5,
                  ),
                ),
                Divider(height: 5.0),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                    flex: 1,
                    child: ListView.builder(
                      controller: controller,
                      shrinkWrap: true,
                      itemCount: selectedItems.length,
                      itemBuilder: (context, index) {
                        return AddQuantityToFoodTile(
                            index: index,
                            meal_data: selectedItems[index],
                            quantity: (selectedItemsQuantity[index].isFinite)
                                ? selectedItemsQuantity[index]
                                : selectedItems[index].quantity_in_grams,
                            currentQuantity: (double currentQuantity) {
                              setState(() {
                                if (currentQuantity.toInt() == 0) {
                                  selectedItems.remove(selectedItems[index]);
                                  selectedItemsQuantity
                                      .remove(selectedItemsQuantity[index]);
                                } else {
                                  selectedItemsQuantity[index] =
                                      currentQuantity;
                                }

                                if (selectedItems.length > 0) {
                                  showDone = true;
                                } else {
                                  selectedItems =
                                      List<NutritionDatabaseModel>();
                                  selectedItemsQuantity = List<double>();
                                  showDone = false;
                                }
                              });
                            });
                      },
                    )),
              ]),
            ),
            Positioned(
              child: Container(
                  color: DashboardTheme.nearlyWhite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return SearchTile(
                          meal_data: items[index],
                          selectionDefault: false,
                          isSelected: (bool value) {
                            setState(() {
                              selectedItems.add(items[index]);
                              selectedItemsQuantity
                                  .add(items[index].quantity_in_grams);
                              items = List<NutritionDatabaseModel>();
                            });
                          });
                    },
                  )),
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    filterSearchResults(value);
                  },
                  controller: editingController,
                  decoration: InputDecoration(
                      fillColor: DashboardTheme.background,
                      labelText: "Search",
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(15.0)))),
                ),
              )),
            )
          ],
        ));
  }
}
