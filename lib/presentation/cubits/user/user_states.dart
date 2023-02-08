import 'package:equatable/equatable.dart';
import 'package:shoghlak/domin/entities/user/user_entity.dart';

abstract class UserStates extends Equatable {
  const UserStates();
}

class UserInitial extends UserStates {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UserLoading extends UserStates {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UserLoaded extends UserStates {
  final List<UserEntity> users;

  UserLoaded({required this.users});
  @override
  // TODO: implement props
  List<Object?> get props => [users];
}

class UserFailure extends UserStates {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
