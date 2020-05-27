import 'dart:async';
import 'dart:developer' as developer;

import 'package:equatable/equatable.dart';

import './bmi_bloc.dart';
import 'package:meta/meta.dart';
import './bmi_state.dart';
@immutable
abstract class BmiEvent {
}

class FetchBMI extends BmiEvent {
}

class AddBMI extends BmiEvent {
    final String lastLoggedTime;
  final double weight_in_kgs, bmi, height_in_cm, bodyfat;

  AddBMI({this.lastLoggedTime, this.weight_in_kgs, this.bmi, this.height_in_cm, this.bodyfat});
}

class UpdateBMI extends BmiEvent {
}