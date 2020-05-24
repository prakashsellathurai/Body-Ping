import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:gkfit/model/trackers/calorieTracker/breakfastModel.dart';
import 'package:gkfit/model/trackers/calorieTracker/dinnerModel.dart';
import 'package:gkfit/model/trackers/calorieTracker/entireDayMealModel.dart';
import 'package:gkfit/model/trackers/calorieTracker/eveningSnackNodel.dart';
import 'package:gkfit/model/trackers/calorieTracker/lunchModel.dart';
import 'package:gkfit/model/trackers/calorieTracker/morningSnackModel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';

import 'dart:developer' as developer;

abstract class CalorieIntakeState extends Equatable {
  final EntireDayMealModel entireDayMeal;

  CalorieIntakeState({this.entireDayMeal});

  double get totalEatenInKcal;
  double get totalCarbs;
  double get totalfat;
  double get totalfibres;
  double get totalproteins;

  @override
  List<Object> get props => [];
}

class CalorieIntakeStateUninitialized extends CalorieIntakeState {
  final EntireDayMealModel entireDayMeal;
  CalorieIntakeStateUninitialized({this.entireDayMeal});
  @override
  List<Object> get props => [
        entireDayMeal,
        totalEatenInKcal,
        totalCarbs,
        totalfat,
        totalfibres,
        totalproteins
      ];

  @override
  // TODO: implement totalEatenInKcal
  double get totalEatenInKcal => double.parse('0');

  @override
  // TODO: implement totalCarbs
  double get totalCarbs => double.parse('0');

  @override
  // TODO: implement totalfat
  double get totalfat => double.parse('0');

  @override
  // TODO: implement totalfibres
  double get totalfibres => double.parse('0');

  @override
  // TODO: implement totalproteins
  double get totalproteins => double.parse('0');
}

class CalorieIntakeStateinitialized extends CalorieIntakeState {
  final EntireDayMealModel entireDayMeal;
  CalorieIntakeStateinitialized({this.entireDayMeal});

  @override
  List<Object> get props => [
        this.entireDayMeal,
      ];

  CalorieIntakeStateinitialized copyWith(
      {String date,
      BreakFastModel breakfast,
      MorningSnackModel morningSnack,
      LunchModel lunch,
      EveningSnackModel eveningSnack,
      DinnerModel dinner}) {
      print(EntireDayMealModel(
            date: date ?? this.entireDayMeal.date,
            breakfast: breakfast ?? entireDayMeal.breakfast,
            morning_snack: morningSnack ?? entireDayMeal.morning_snack,
            lunch: lunch ?? this.entireDayMeal.lunch,
            evening_snack: eveningSnack ?? this.entireDayMeal.evening_snack,
            dinner: dinner ?? this.entireDayMeal.dinner).breakfast.toJson());
    return CalorieIntakeStateinitialized(
        entireDayMeal: EntireDayMealModel(
            date: date ?? this.entireDayMeal.date,
            breakfast: breakfast ?? entireDayMeal.breakfast,
            morning_snack: morningSnack ?? entireDayMeal.morning_snack,
            lunch: lunch ?? this.entireDayMeal.lunch,
            evening_snack: eveningSnack ?? this.entireDayMeal.evening_snack,
            dinner: dinner ?? this.entireDayMeal.dinner));
  }

  @override
  // TODO: implement totalEatenInKcal
  double get totalEatenInKcal =>
 ((this.entireDayMeal.breakfast.total_calories ?? 0 +
                this.entireDayMeal.morning_snack.total_calories ?? 0 +
                this.entireDayMeal.lunch.total_calories ?? 0 +
                this.entireDayMeal.evening_snack.total_calories ?? 0 +
                this.entireDayMeal.dinner.total_calories ?? 0) /
            1000) ??
        0;
  

  @override
  // TODO: implement totalCarbs
  double get totalCarbs =>
     (entireDayMeal.breakfast.totalCarbsInGrams ?? 0+
        entireDayMeal.morning_snack.totalCarbsInGrams ?? 0+
        entireDayMeal.lunch.totalCarbsInGrams ?? 0+
        entireDayMeal.evening_snack.totalCarbsInGrams ?? 0+
        entireDayMeal.dinner.totalCarbsInGrams) ?? 0;
  

  @override
  // TODO: implement totalfat
  double get totalfat => (entireDayMeal.breakfast.totalFatInGrams ?? 0+
      entireDayMeal.morning_snack.totalFatInGrams ?? 0+
      entireDayMeal.lunch.totalFatInGrams ?? 0+
      entireDayMeal.evening_snack.totalFatInGrams?? 0 +
      entireDayMeal.dinner.totalFatInGrams ?? 0);

  @override
  // TODO: implement totalfibres
  double get totalfibres => (entireDayMeal.breakfast.totalFibresInGrams ?? 0+
      entireDayMeal.morning_snack.totalFibresInGrams?? 0 +
      entireDayMeal.lunch.totalFibresInGrams ?? 0 +
      entireDayMeal.evening_snack.totalFibresInGrams ?? 0+
      entireDayMeal.dinner.totalFibresInGrams ?? 0);

  @override
  // TODO: implement totalproteins
  double get totalproteins => (entireDayMeal.breakfast.totalproteinsInGrams ?? 0+
      entireDayMeal.morning_snack.totalproteinsInGrams ?? 0+
      entireDayMeal.lunch.totalproteinsInGrams ?? 0+
      entireDayMeal.evening_snack.totalproteinsInGrams?? 0 +
      entireDayMeal.dinner.totalproteinsInGrams?? 0);
}

class CalorieIntakeStateError extends CalorieIntakeState {
  CalorieIntakeStateError(EntireDayMealModel entiredayMeal);
  @override
  List<Object> get props => [entireDayMeal];
  @override
  // TODO: implement totalEatenInKcal
  double get totalEatenInKcal => throw UnimplementedError();

  @override
  // TODO: implement totalCarbs
  double get totalCarbs => throw UnimplementedError();

  @override
  // TODO: implement totalfat
  double get totalfat => throw UnimplementedError();

  @override
  // TODO: implement totalfibres
  double get totalfibres => throw UnimplementedError();

  @override
  // TODO: implement totalproteins
  double get totalproteins => throw UnimplementedError();
}
