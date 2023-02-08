import 'package:equatable/equatable.dart';

abstract class CredentialStates extends Equatable {
  const CredentialStates();
}

class CredentialInitial extends CredentialStates{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}


class CredentialLoading extends CredentialStates{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}


class CredentialSuccess extends CredentialStates{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}


class CredentialFailure extends CredentialStates{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
