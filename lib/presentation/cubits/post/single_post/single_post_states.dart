import 'package:equatable/equatable.dart';
import 'package:shoghlak/domin/entities/post/post_entity.dart';

abstract class GetSinglePostStates extends Equatable {
  const GetSinglePostStates();
}

class GetSinglePostInitial extends GetSinglePostStates {
  @override
  List<Object?> get props => [];
}

class GetSinglePostLoading extends GetSinglePostStates {
  @override
  List<Object?> get props => [];
}

class GetSinglePostLoaded extends GetSinglePostStates {
  final PostEntity post;

  const GetSinglePostLoaded({required this.post});
  @override
  List<Object?> get props => [post];
}

class GetSinglePostFailure extends GetSinglePostStates {
  @override
  List<Object?> get props => [];
}
