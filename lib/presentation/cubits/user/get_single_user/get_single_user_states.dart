import 'package:equatable/equatable.dart';
import 'package:shoghlak/domin/entities/user/user_entity.dart';

abstract class GetSingleUserStates extends Equatable {
  const GetSingleUserStates();
}

class GetSingleUserInitial extends GetSingleUserStates {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetSingleUserLoading extends GetSingleUserStates {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class GetSingleUserLoaded extends GetSingleUserStates {
  final UserEntity user;

  GetSingleUserLoaded({required this.user});
  @override
  // TODO: implement props
  List<Object?> get props => [user];
}

class GetSingleUserFailure extends GetSingleUserStates {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
