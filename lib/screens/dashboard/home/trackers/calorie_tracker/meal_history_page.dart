import 'package:flutter/material.dart';
import '../../../dashboard_theme.dart';
import 'package:gkfit/repository/CalorietrackerRepository.dart';
import 'package:gkfit/model/trackers/calorieTracker/entireDayMealModel.dart';
import 'package:provider/provider.dart';

import 'package:gkfit/widgets/loading/loadingIndicator.dart';
import 'package:intl/intl.dart';
import 'package:gkfit/model/trackers/calorieTracker/breakfastModel.dart';
import 'package:gkfit/model/trackers/calorieTracker/dinnerModel.dart';
import 'package:gkfit/model/trackers/calorieTracker/entireDayMealModel.dart';
import 'package:gkfit/model/trackers/calorieTracker/eveningSnackNodel.dart';
import 'package:gkfit/model/trackers/calorieTracker/lunchModel.dart';
import 'package:gkfit/model/trackers/calorieTracker/morningSnackModel.dart';
import 'package:gkfit/model/trackers/Nutrition_database_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gkfit/bloc/authentication/authentication_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
class MealHistoryScreen extends StatefulWidget {
  MealHistoryScreen({Key key}) : super(key: key);

  @override
  _MealHistoryScreenState createState() => _MealHistoryScreenState();
}

class _MealHistoryScreenState extends State<MealHistoryScreen> {
  CalorieTrackerRepository _calorieTrackerRepository =
      CalorieTrackerRepository();
 FirebaseUser   user;
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
        centerTitle: true,
        title: Text(
          "Your Meal History",
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: Colors.black),
        ),
      ),
      backgroundColor: DashboardTheme.background,
      body: FutureBuilder(
        future: _future(),
        builder: (BuildContext context,
            AsyncSnapshot<List<EntireDayMealModel>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              List<EntireDayMealModel> mealList = snapshot.data;
              List<Entry> data = <Entry>[];
              for (EntireDayMealModel meal in mealList) {
                var formatter = new DateFormat.yMEd();
                List<Entry> breakfastList = [];
                List<Entry> morningSnackList = [];
                List<Entry> lunchList = [];
                List<Entry> eveningList = [];
                List<Entry> dinnerList = [];

                for (NutritionDatabaseModel _meal in meal.breakfast.meal_list) {
                  breakfastList.add(Entry(
                      "\n${meal.breakfast.meal_list.indexOf(_meal) + 1}. ${_meal.name} \n  Quantity: ${_meal.quantity_in_grams} grams\n"));
                }

                for (NutritionDatabaseModel _meal
                    in meal.morning_snack.meal_list) {
                  morningSnackList.add(Entry(
                      "\n${meal.morning_snack.meal_list.indexOf(_meal) + 1}. ${_meal.name} \n  Quantity: ${_meal.quantity_in_grams} grams\n"));
                }

                for (NutritionDatabaseModel _meal in meal.lunch.meal_list) {
                  lunchList.add(Entry(
                      "\n${meal.lunch.meal_list.indexOf(_meal) + 1}. ${_meal.name} \n  Quantity: ${_meal.quantity_in_grams} grams\n"));
                }

                for (NutritionDatabaseModel _meal
                    in meal.evening_snack.meal_list) {
                  eveningList.add(Entry(
                      "\n${meal.evening_snack.meal_list.indexOf(_meal) + 1}. ${_meal.name} \n  Quantity: ${_meal.quantity_in_grams} grams\n"));
                }

                for (NutritionDatabaseModel _meal in meal.dinner.meal_list) {
                  dinnerList.add(Entry(
                      "\n${meal.dinner.meal_list.indexOf(_meal) + 1}. ${_meal.name} \n  Quantity: ${_meal.quantity_in_grams} grams\n"));
                }

                Entry mealDataEntry = Entry(
                    formatter
                        .format(DateTime.parse(meal.date).toLocal())
                        .toString(),
                    [
                      Entry("BreakFast", breakfastList),
                      Entry("Morning Snack", morningSnackList),
                      Entry("Lunch", lunchList),
                      Entry("Evening Snack", eveningList),
                      Entry("Dinner", dinnerList),
                    ]);
                // print(meal.toJson());
                data.add(mealDataEntry);
              }
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) =>
                    EntryItem(data[index]),
                itemCount: data.length,
              );
            } else {
              return Text("empty");
            }
          }
          return Center(
            child: LoadingIndicator(),
          );
        },
      ),
    );
  }

  Future<List<EntireDayMealModel>> _future() async {
    user = BlocProvider.of<AuthenticationBloc>(context).state.user;
    List<EntireDayMealModel> autogen =
        await _calorieTrackerRepository.fetchEntireMealHistory(user.uid);
    return autogen;
  }
}

// One entry in the multilevel list displayed by this app.
class Entry {
  Entry(this.title, [this.children = const <Entry>[]]);

  final String title;
  final List<Entry> children;
}

// The entire multilevel list displayed by this app.
final List<Entry> data = <Entry>[
  Entry(
    'Chapter A',
    <Entry>[
      Entry(
        'Section A0',
        <Entry>[
          Entry('Item A0.1'),
          Entry('Item A0.2'),
          Entry('Item A0.3'),
        ],
      ),
      Entry('Section A1'),
      Entry('Section A2'),
    ],
  ),
  Entry(
    'Chapter B',
    <Entry>[
      Entry('Section B0'),
      Entry('Section B1'),
    ],
  ),
  Entry(
    'Chapter C',
    <Entry>[
      Entry('Section C0'),
      Entry('Section C1'),
      Entry(
        'Section C2',
        <Entry>[
          Entry('Item C2.0'),
          Entry('Item C2.1'),
          Entry('Item C2.2'),
          Entry('Item C2.3'),
        ],
      ),
    ],
  ),
];

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) return ListTile(title: Text(root.title));
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(root.title),
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}
