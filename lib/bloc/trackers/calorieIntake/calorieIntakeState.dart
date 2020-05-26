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
    return CalorieIntakeStateinitialized(
        entireDayMeal: EntireDayMealModel(
            date: date ?? this.entireDayMeal.date,
            breakfast: breakfast ?? entireDayMeal.breakfast,
            morning_snack: morningSnack ?? entireDayMeal.morning_snack,
            lunch: lunch ?? this.entireDayMeal.lunch,
            evening_snack: eveningSnack ?? this.entireDayMeal.evening_snack,
            dinner: dinner ?? this.entireDayMeal.dinner));
  }

  calculateTotalCalories() {
    double breakfastTotalCalorie =
        this.entireDayMeal.breakfast.total_calories ?? 0;
    double morning_snackTotalCalorie =
        this.entireDayMeal.morning_snack.total_calories ?? 0;
    double lunchTotalCalorie = this.entireDayMeal.lunch.total_calories ?? 0;
    double evening_snackTotalCalorie =
        this.entireDayMeal.evening_snack.total_calories ?? 0;
    double dinnerTotalCalorie = this.entireDayMeal.dinner.total_calories ?? 0;
    double totalCalorie = breakfastTotalCalorie +
        morning_snackTotalCalorie +
        lunchTotalCalorie +
        evening_snackTotalCalorie +
        dinnerTotalCalorie;
    totalCalorie = totalCalorie / 1000;
    return totalCalorie;
  }

  caculateTotalFat() {
    double breakfastFat = entireDayMeal.breakfast.totalFatInGrams ?? 0;
    double morning_snackFat = entireDayMeal.morning_snack.totalFatInGrams ?? 0;
    double lunchFat = entireDayMeal.lunch.totalFatInGrams ?? 0;
    double evening_snackFat = entireDayMeal.evening_snack.totalFatInGrams ?? 0;
    double dinnerFat = entireDayMeal.dinner.totalFatInGrams ?? 0;
    double totalFat = breakfastFat +
        morning_snackFat +
        lunchFat +
        evening_snackFat +
        dinnerFat;
    return totalFat;
  }

  caculateTotalCarbs() {
    double breakfastCarbs = entireDayMeal.breakfast.totalCarbsInGrams ?? 0;
    double morning_snackCarbs =
        entireDayMeal.morning_snack.totalCarbsInGrams ?? 0;
    double lunchCarbs = entireDayMeal.lunch.totalCarbsInGrams ?? 0;
    double evening_snackCarbs =
        entireDayMeal.evening_snack.totalCarbsInGrams ?? 0;
    double dinnerCarbs = entireDayMeal.dinner.totalCarbsInGrams ?? 0;
    double totalCarbs = breakfastCarbs +
        morning_snackCarbs +
        lunchCarbs +
        evening_snackCarbs +
        dinnerCarbs;
    return totalCarbs;
  }

  caculateTotalFibres() {
        double breakfastFibres = entireDayMeal.breakfast.totalFibresInGrams ?? 0;
    double morning_snackFibres =
        entireDayMeal.morning_snack.totalFibresInGrams ?? 0;
    double lunchFibres = entireDayMeal.lunch.totalFibresInGrams ?? 0;
    double evening_snackFibres =
        entireDayMeal.evening_snack.totalFibresInGrams ?? 0;
    double dinnerFibres = entireDayMeal.dinner.totalFibresInGrams ?? 0;
    double totalFibres = breakfastFibres +
        morning_snackFibres +
        lunchFibres +
        evening_snackFibres +
        dinnerFibres;
    return totalFibres;
  }
  caculateTotalProteins() {
        double breakfastProteins = entireDayMeal.breakfast.totalproteinsInGrams ?? 0;
    double morning_snackProteins =
        entireDayMeal.morning_snack.totalproteinsInGrams ?? 0;
    double lunchProteins = entireDayMeal.lunch.totalproteinsInGrams ?? 0;
    double evening_snackProteins =
        entireDayMeal.evening_snack.totalproteinsInGrams ?? 0;
    double dinnerProteins = entireDayMeal.dinner.totalproteinsInGrams ?? 0;
    double totalProteins = breakfastProteins +
        morning_snackProteins +
        lunchProteins +
        evening_snackProteins +
        dinnerProteins;
    return totalProteins;
  }
  @override
  // TODO: implement totalEatenInKcal
  double get totalEatenInKcal => calculateTotalCalories();

  @override
  // TODO: implement totalCarbs
  double get totalCarbs => caculateTotalCarbs();

  @override
  // TODO: implement totalfat
  double get totalfat => caculateTotalFat();

  @override
  // TODO: implement totalfibres
  double get totalfibres => caculateTotalFibres();

  @override
  // TODO: implement totalproteins
  double get totalproteins => caculateTotalProteins();
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
