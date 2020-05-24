import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

abstract class WaterIntakeState extends Equatable {
  /// notify change state without deep clone state
  final int version;

  final List propss;
  WaterIntakeState(this.version, [this.propss]);

  /// Copy object for use in action
  /// if need use deep clone
  int getCurrentQuantityInMl();

  String getDay();

  String getLastWaterIntake();
  @override
  List<Object> get props => ([version, ...propss ?? []]);
}

/// UnInitialized
class UnWaterIntakeState extends WaterIntakeState {
  UnWaterIntakeState(int version) : super(version);

  @override
  String toString() => 'UnWaterIntakeState';

  @override
  int getCurrentQuantityInMl() {
    // TODO: implement getCurrentQuantityInMl
    return 0;
  }

  @override
  String getDay() {
    // TODO: implement getDay
    return DateTime(DateTime.now().day).toIso8601String();
  }

  @override
  String getLastWaterIntake() {
    // TODO: implement getDay
    return '';
  }
}

/// Initialized
class InWaterIntakeState extends WaterIntakeState {
  final int quantity_in_ml;
  final String day;
  String lastWaterIntake;

  InWaterIntakeState(int version, this.quantity_in_ml, this.day,this.lastWaterIntake)
      : super(version, [quantity_in_ml, day]);

  @override
  String toString() => 'InWaterIntakeState $quantity_in_ml $day';

  InWaterIntakeState copyWith(quantity_in_ml, day, lastWaterIntake) {
    print(lastWaterIntake);
    return InWaterIntakeState(version + 1, quantity_in_ml, day,lastWaterIntake);
  }



  @override
  int getCurrentQuantityInMl() {
    // TODO: implement getCurrentQuantityInMl
    return quantity_in_ml;
  }

  @override
  String getDay() {
    // TODO: implement getDay
    return day;
  }

  @override
  String getLastWaterIntake() {
    // TODO: implement getDay
    return  this.lastWaterIntake ?? '';
  }
}

class ErrorWaterIntakeState extends WaterIntakeState {
  final String errorMessage;

  ErrorWaterIntakeState(int version, this.errorMessage)
      : super(version, [errorMessage]);

  @override
  String toString() => 'ErrorWaterIntakeState';

  @override
  ErrorWaterIntakeState getStateCopy() {
    return ErrorWaterIntakeState(version, errorMessage);
  }

  @override
  ErrorWaterIntakeState getNewVersion() {
    return ErrorWaterIntakeState(version + 1, errorMessage);
  }

  @override
  int getCurrentQuantityInMl() {
    // TODO: implement getCurrentQuantityInMl
    throw UnimplementedError();
  }

  @override
  String getDay() {
    // TODO: implement getDay
    throw UnimplementedError();
  }

  @override
  String getLastWaterIntake() {
    // TODO: implement getDay
    throw UnimplementedError();
  }
}
