import 'package:equatable/equatable.dart';
import 'package:gkfit/model/trackers/Nutrition_database_model.dart';

class CalorieIntakeEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class AddBreakFastEvent extends CalorieIntakeEvent {
  List<NutritionDatabaseModel> meallist;
  List<double> mealListQuantity;
  double totalCalories;
  List<double> calories_list;
  AddBreakFastEvent({this.meallist,this.mealListQuantity,this.totalCalories,this.calories_list});
}
class AddMorningSnack extends CalorieIntakeEvent {
  List<NutritionDatabaseModel> meallist;
  List<double> mealListQuantity;
  double totalCalories;
  List<double> calories_list;
  AddMorningSnack({this.meallist,this.mealListQuantity,this.totalCalories,this.calories_list});
}
class AddLunch extends CalorieIntakeEvent {
  List<NutritionDatabaseModel> meallist;
  List<double> mealListQuantity;
  double totalCalories;
  List<double> calories_list;
  AddLunch({this.meallist,this.mealListQuantity,this.totalCalories,this.calories_list});
}
class AddEveningSnack extends CalorieIntakeEvent {
  List<NutritionDatabaseModel> meallist;
  List<double> mealListQuantity;
  double totalCalories;
  List<double> calories_list;
  AddEveningSnack({this.meallist,this.mealListQuantity,this.totalCalories,this.calories_list});
}
class AddDinner extends CalorieIntakeEvent {
  List<NutritionDatabaseModel> meallist;
  List<double> mealListQuantity;
  double totalCalories;
  List<double> calories_list;
  AddDinner({this.meallist,this.mealListQuantity,this.totalCalories,this.calories_list});
}
class FetchEntiredayMealModelEvent extends CalorieIntakeEvent {}
class UpdateEntiredayMealModelIndatabaseEvent extends CalorieIntakeEvent {}

class UpdateBreakfastModelIndatabaseEvent extends CalorieIntakeEvent {}
class UpdateMorningSnackModelIndatabaseEvent extends CalorieIntakeEvent {}
class UpdateLunchlModelIndatabaseEvent extends CalorieIntakeEvent {}
class UpdateEveneingMealModelIndatabaseEvent extends CalorieIntakeEvent {}
class UpdateDinnerModelIndatabaseEvent extends CalorieIntakeEvent {}