import 'package:equatable/equatable.dart';

abstract class BmiState extends Equatable {
  final List propss;
  BmiState([this.propss]);
  String lastLoggedTime;
  double weight_in_kgs, bmi, height_in_cm, bodyfat;
  @override
  List<Object> get props => (propss ?? []);
}

/// UnInitialized
class UnBmiState extends BmiState {
  String lastLoggedTime;
  double weight_in_kgs, bmi, height_in_cm, bodyfat;
  @override
  String toString() => 'UnBmiState';
  @override
  List<Object> get props => [];
}

/// Initialized
class InBmiState extends BmiState {
  final String lastLoggedTime;
  final double weight_in_kgs, bmi, height_in_cm, bodyfat;

  InBmiState({this.lastLoggedTime, this.weight_in_kgs, this.bmi,
      this.height_in_cm, this.bodyfat})
      : super([lastLoggedTime, weight_in_kgs, bmi, height_in_cm, bodyfat]);

   InBmiState copyWith({
      lastLoggedTime, weight_in_kgs, bmi, height_in_cm, bodyfat}) {
    return InBmiState(
      lastLoggedTime: lastLoggedTime ?? this.lastLoggedTime,
      weight_in_kgs: weight_in_kgs ?? this.weight_in_kgs,
      bmi: bmi ?? this.bmi,
      height_in_cm: height_in_cm ?? this.height_in_cm,
      bodyfat: bodyfat ?? this.bodyfat
    );
  }
  @override
  String toString() => 'InBmiState $lastLoggedTime ';
}

class ErrorBmiState extends BmiState {
  final String errorMessage;

  ErrorBmiState(this.errorMessage) : super([errorMessage]);

  @override
  String toString() => 'ErrorBmiState';
  @override
  List<Object> get props => [errorMessage];
}
