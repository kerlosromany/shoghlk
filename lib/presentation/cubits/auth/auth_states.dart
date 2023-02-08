import 'package:equatable/equatable.dart';

abstract class AuthStates extends Equatable {
  const AuthStates();
}

class AuthInitial extends AuthStates {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class Authenticated extends AuthStates {
  final String uid;

  Authenticated({required this.uid});
  @override
  // TODO: implement props
  List<Object?> get props => [uid];
}

class UnAuthenticated extends AuthStates {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UnAuthenticatedFailure extends AuthStates {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}


