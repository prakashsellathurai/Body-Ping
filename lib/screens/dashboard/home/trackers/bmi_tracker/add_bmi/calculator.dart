import 'dart:math' as math;

double calculateBMI({int height, int weight}) =>
    weight / _heightSquared(height);

double calculateMinNormalWeight({int height}) => 18.5 * _heightSquared(height);

double calculateMaxNormalWeight({int height}) => 25 * _heightSquared(height);

double _heightSquared(int height) => math.pow(height / 100, 2);

double calculateBodyFat({double bmi, int age, String gender}) {
  if (gender == "Male") {
    return ((1.20 * bmi) + (0.23 * age.toDouble())) - 5.4;
  } else {
    return ((1.20 * bmi) + (0.23 * age.toDouble())) - 16.2;
  }
}
int calculateAge(DateTime birthDate) {
  DateTime currentDate = DateTime.now();
  int age = currentDate.year - birthDate.year;
  int month1 = currentDate.month;
  int month2 = birthDate.month;
  if (month2 > month1) {
    age--;
  } else if (month1 == month2) {
    int day1 = currentDate.day;
    int day2 = birthDate.day;
    if (day2 > day1) {
      age--;
    }
  }
  return age;
}