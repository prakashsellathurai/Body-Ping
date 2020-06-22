import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gkfit/bloc/authentication/bloc.dart';
import 'package:gkfit/repository/user_repository.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository = UserRepository();

  @override
  AuthenticationState get initialState => AuthenticationInitial();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationStarted) {
      yield* _mapAuthenticationStartedToState();
    } else if (event is AuthenticationLogIn) {
      yield* _mapAuthenticationLoggedInToState();
    } else if (event is AuthenticationLogOut) {
      yield* _mapAuthenticationLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAuthenticationStartedToState() async* {
    try {
      final isSignedIn = await _userRepository.isSignedIn();
      if (isSignedIn) {
        yield AuthenticationProcessing();
        final name = await _userRepository.getUser();
        yield AuthenticationSuccess(name);
      } else {
        yield AuthenticationLoggedOut();
      }
    } catch (e) {
      print(e);
      yield AuthenticationFailure();
    }
  }

  Stream<AuthenticationState> _mapAuthenticationLoggedInToState() async* {
    yield AuthenticationSuccess(await _userRepository.getUser());
  }

  Stream<AuthenticationState> _mapAuthenticationLoggedOutToState() async* {
    _userRepository.signOut();
    yield AuthenticationLoggedOut();
  }


}
