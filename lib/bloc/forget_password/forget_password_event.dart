import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class ForgetPasswordEvent extends Equatable {
  const ForgetPasswordEvent();

  @override
  List<Object> get props => [];
}

class RegisterEmailChanged extends ForgetPasswordEvent {
  final String email;

  const RegisterEmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged { email :$email }';
}


class RegisterSubmitted extends ForgetPasswordEvent {
  final String email;

  const RegisterSubmitted({
    @required this.email,
  });

  @override
  List<Object> get props => [email];

  @override
  String toString() {
    return 'Submitted { email: $email, }';
  }
}
