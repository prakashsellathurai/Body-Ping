part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];

  FirebaseUser get user => null;
}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  final FirebaseUser user;

  const AuthenticationSuccess(this.user);

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'Authenticated { displayName: ${user.displayName} }';
}

class AuthenticationProcessing extends AuthenticationState {
  @override
  List<Object> get props => ["processing"];
  @override
  String toString() => 'Authentication under process ';
}
class AuthenticationLoggedOut extends AuthenticationState {
  @override
  List<Object> get props => ["logged out"];
  @override
  String toString() => 'Authentication : logged Out';
}
class AuthenticationFailure extends AuthenticationState {
  @override
  List<Object> get props => [null];
  @override
  String toString() => 'Authentication Failure ';
}
