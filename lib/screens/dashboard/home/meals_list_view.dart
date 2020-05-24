import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gkfit/bloc/trackers/calorieIntake/CalorieIntakeBloc.dart';
import 'package:gkfit/bloc/trackers/calorieIntake/calorieIntakeState.dart';
import 'package:gkfit/bloc/trackers/calorieIntake/CalorieIntakeEvent.dart';
import './../../../model/DailyRequiremnentModel.dart';
import '../dashboard_theme.dart';
import './../../../model/dashboard/meals_list_data.dart';
import './../../../constants/colors.dart';
import 'package:flutter/material.dart';
import './trackers/calorie_tracker/add_meal.dart_page.dart';
import 'dart:developer' as developer;

class MealsListView extends StatefulWidget {
  const MealsListView(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController mainScreenAnimationController;
  final Animation<dynamic> mainScreenAnimation;

  @override
  _MealsListViewState createState() => _MealsListViewState();
}

class _MealsListViewState extends State<MealsListView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  CalorieIntakeBloc calorieIntakeBloc;
  DailyRequirements dailyRequirements = DailyRequirements();
  List<MealsListData> mealsListData;
  @override
  void initState() {
    calorieIntakeBloc = BlocProvider.of<CalorieIntakeBloc>(context);
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  List<MealsListData> updateMealListData(calorieIntakeBloc, context) {
    List<MealsListData> meallistdata = <MealsListData>[
      MealsListData(
          titleTxt: 'Breakfast',
          kacl:
              calorieIntakeBloc
                      .state.entireDayMeal.breakfast.total_calories ??
                  0,
          meals: (calorieIntakeBloc
                      .state.entireDayMeal.breakfast.mealStringList.length >
                  0)
              ? calorieIntakeBloc.state.entireDayMeal.breakfast.mealStringList
              : <String>[
                  'Recommend:',
                  '${dailyRequirements.recomendedBreakfastCalories} kcal'
                ],
          mealListFromDatabase:
              calorieIntakeBloc.state.entireDayMeal.breakfast.meal_list,
          startColor: '#FA7D82',
          endColor: '#FFB295',
          mealSelector: 'breakfast',
          mealListQuantityInGrams: calorieIntakeBloc
              .state.entireDayMeal.breakfast.quantities_in_grams),
      MealsListData(
          titleTxt: 'Morning Snack',
          kacl: calorieIntakeBloc
                  .state.entireDayMeal.morning_snack.total_calories ??
              0,
          meals: (calorieIntakeBloc
                      .state.entireDayMeal.morning_snack.mealStringList.length >
                  0)
              ? calorieIntakeBloc
                  .state.entireDayMeal.morning_snack.mealStringList
              : <String>[
                  'Recommend:',
                  '${dailyRequirements.recomendedMorningSnackCalories} kcal'
                ],
          mealListFromDatabase:
              calorieIntakeBloc.state.entireDayMeal.morning_snack.meal_list,
          startColor: '#41B4BC',
          endColor: '#00D4FF',
          mealSelector: 'morningSnack',
          mealListQuantityInGrams: calorieIntakeBloc
              .state.entireDayMeal.morning_snack.quantities_in_grams),
      MealsListData(
          titleTxt: 'Lunch',
          kacl: calorieIntakeBloc.state.entireDayMeal.lunch.total_calories ?? 0,
          meals: (calorieIntakeBloc
                      .state.entireDayMeal.lunch.mealStringList.length >
                  0)
              ? calorieIntakeBloc.state.entireDayMeal.lunch.mealStringList
              : <String>[
                  'Recommend:',
                  '${dailyRequirements.recomendedlunchCalories} kcal'
                ],
          mealListFromDatabase:
              calorieIntakeBloc.state.entireDayMeal.lunch.meal_list,
          startColor: '#738AE6',
          endColor: '#5C5EDD',
          mealSelector: 'lunch',
          mealListQuantityInGrams:
              calorieIntakeBloc.state.entireDayMeal.lunch.quantities_in_grams),
      MealsListData(
          titleTxt: 'Evening Snack',
          kacl: calorieIntakeBloc
                  .state.entireDayMeal.evening_snack.total_calories ??
              0,
          meals: (calorieIntakeBloc
                      .state.entireDayMeal.evening_snack.mealStringList.length >
                  0)
              ? calorieIntakeBloc
                  .state.entireDayMeal.evening_snack.mealStringList
              : <String>[
                  'Recommend:',
                  '${dailyRequirements.recomendedeveningSnackCalories} kcal'
                ],
          mealListFromDatabase:
              calorieIntakeBloc.state.entireDayMeal.evening_snack.meal_list,
          startColor: '#FE95B6',
          endColor: '#FF5287',
          mealSelector: 'eveningSnack',
          mealListQuantityInGrams: calorieIntakeBloc
              .state.entireDayMeal.evening_snack.quantities_in_grams),
      MealsListData(
          titleTxt: 'Dinner',
          kacl:
              calorieIntakeBloc.state.entireDayMeal.dinner.total_calories ?? 0,
          meals: (calorieIntakeBloc
                      .state.entireDayMeal.dinner.mealStringList.length >
                  0)
              ? calorieIntakeBloc.state.entireDayMeal.dinner.mealStringList
              : <String>[
                  'Recommend:',
                  '${dailyRequirements.recomendedDinnerCalories} kcal'
                ],
          mealListFromDatabase:
              calorieIntakeBloc.state.entireDayMeal.dinner.meal_list,
          startColor: '#6F72CA',
          endColor: '#1E1466',
          mealSelector: 'dinner',
          mealListQuantityInGrams:
              calorieIntakeBloc.state.entireDayMeal.dinner.quantities_in_grams),
    ];
    return meallistdata;
  }

  @override
  Widget build(BuildContext context) {
    calorieIntakeBloc = BlocProvider.of<CalorieIntakeBloc>(context);
    mealsListData = updateMealListData(calorieIntakeBloc, context);
    print("rebuild the meal list view");
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation.value), 0.0),
            child: Container(
              height: 216,
              width: double.infinity,
              child: ListView.builder(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 16, left: 16),
                itemCount: mealsListData.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final int count =
                      mealsListData.length > 10 ? 10 : mealsListData.length;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: animationController,
                              curve: Interval((1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn)));
                  animationController.forward();

                  return MealsView(
                    mealsListData: mealsListData[index],
                    animation: animation,
                    animationController: animationController,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
    // } else {
    //   return Container(
    //       child: Center(
    //     child: CircularProgressIndicator(),
    //   ));
    // }
    // return Container(
    //     child: Center(
    //   child: CircularProgressIndicator(),
    // ));
    // });
  }
}

class MealsView extends StatelessWidget {
  const MealsView(
      {Key key, this.mealsListData, this.animationController, this.animation})
      : super(key: key);

  final MealsListData mealsListData;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddMealScreen(
                  meal_title: mealsListData.titleTxt,
                  mealListFromDatabase: mealsListData.mealListFromDatabase,
                  mealSelector: mealsListData.mealSelector,
                  mealQuantityList: mealsListData.mealListQuantityInGrams)));
        },
        child: AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: animation,
              child: Transform(
                transform: Matrix4.translationValues(
                    100 * (1.0 - animation.value), 0.0, 0.0),
                child: SizedBox(
                  width: 130,
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 32, left: 8, right: 8, bottom: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: HexColor(mealsListData.endColor)
                                      .withOpacity(0.6),
                                  offset: const Offset(1.1, 4.0),
                                  blurRadius: 8.0),
                            ],
                            gradient: LinearGradient(
                              colors: <HexColor>[
                                HexColor(mealsListData.startColor),
                                HexColor(mealsListData.endColor),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(8.0),
                              bottomLeft: Radius.circular(8.0),
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 16, right: 16, bottom: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  mealsListData.titleTxt,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: DashboardTheme.fontName,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        (mealsListData.kacl == 0) ? 16 : 12,
                                    letterSpacing: 0.2,
                                    color: DashboardTheme.white,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          mealsListData.meals.join('\n'),
                                          style: TextStyle(
                                            fontFamily: DashboardTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10,
                                            letterSpacing: 0.2,
                                            color: DashboardTheme.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                mealsListData.mealListFromDatabase.length > 0
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            (mealsListData.kacl.toInt() / 1000)
                                                .toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily:
                                                  DashboardTheme.fontName,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
                                              letterSpacing: 0.2,
                                              color: DashboardTheme.white,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4, bottom: 3),
                                            child: Text(
                                              'kcal',
                                              style: TextStyle(
                                                fontFamily:
                                                    DashboardTheme.fontName,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10,
                                                letterSpacing: 0.2,
                                                color: DashboardTheme.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          color: DashboardTheme.nearlyWhite,
                                          shape: BoxShape.circle,
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: DashboardTheme
                                                    .nearlyBlack
                                                    .withOpacity(0.4),
                                                offset: Offset(8.0, 8.0),
                                                blurRadius: 8.0),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Icon(
                                            Icons.add,
                                            color: HexColor(
                                                mealsListData.endColor),
                                            size: 24,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Positioned(
                      //   top: 0,
                      //   left: 0,
                      //   child: Container(
                      //     width: 84,
                      //     height: 84,
                      //     decoration: BoxDecoration(
                      //       color: DashboardTheme.nearlyWhite.withOpacity(0.2),
                      //       shape: BoxShape.circle,
                      //     ),
                      //   ),
                      // ),
                      // Positioned(
                      //   top: 0,
                      //   left: 8,
                      //   child: SizedBox(
                      //     width: 80,
                      //     height: 80,
                      //     child: Image.asset(mealsListData.imagePath),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}
