import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:gkfit/bloc/forget_password/forget_password_event.dart';
import 'package:gkfit/bloc/forget_password/forget_password_state.dart';
import 'package:gkfit/repository/user_repository.dart';
import 'package:gkfit/widgets/validator.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

class ForgetPasswordBloc extends Bloc<ForgetPasswordEvent, ForgetPasswordState> {
  final UserRepository _userRepository;

  ForgetPasswordBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  ForgetPasswordState get initialState => ForgetPasswordState.initial();

  @override
  Stream<Transition<ForgetPasswordEvent, ForgetPasswordState>> transformEvents(
    Stream<ForgetPasswordEvent> events,
    TransitionFunction<ForgetPasswordEvent, ForgetPasswordState> transitionFn,
  ) {
    final nonDebounceStream = events.where((event) {
      return (event is! RegisterEmailChanged );
    });
    final debounceStream = events.where((event) {
      return (event is RegisterEmailChanged );
    }).debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<ForgetPasswordState> mapEventToState(
    ForgetPasswordEvent event,
  ) async* {
    if (event is RegisterEmailChanged) {
      yield* _mapRegisterEmailChangedToState(event.email);
    }  else if (event is RegisterSubmitted) {
      yield* _mapRegisterSubmittedToState(event.email);
    }
  }

  Stream<ForgetPasswordState> _mapRegisterEmailChangedToState(String email) async* {
    yield state.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }



  Stream<ForgetPasswordState> _mapRegisterSubmittedToState(
    String email,
  ) async* {
    yield ForgetPasswordState.loading();
    try {
      await _userRepository.sendPasswordResetEmail(email:email);
      yield ForgetPasswordState.success();
    } catch (e) {
      print(e);
      yield ForgetPasswordState.failure();
    }
  }
}
