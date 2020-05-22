import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class BmiEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class BmiFetch extends BmiEvent {}

class BmiState {
  const BmiState();
  @override
  List<Object> get props => [];

}

class BmiUnitialized extends BmiState {}

class BmiFetchError extends BmiState {}

class BmiAdded extends BmiState {

}
class BmiBloc extends Bloc<BmiEvent, BmiState> {

  @override
  BmiState get initialState => BmiUnitialized();

  @override
  Stream<BmiState> mapEventToState(
    BmiEvent event,
  ) async* {
    try {

    } catch (_, stackTrace) {
      developer.log('$_', name: 'BmiBloc', error: _, stackTrace: stackTrace);
      yield state;
    }
  }
}
