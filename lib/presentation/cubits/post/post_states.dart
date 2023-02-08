import 'package:equatable/equatable.dart';
import 'package:shoghlak/domin/entities/post/post_entity.dart';

abstract class PostStates extends Equatable {
  const PostStates();
}

class PostInitial extends PostStates {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class PostLoading extends PostStates {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class PostLoaded extends PostStates {
  final List<PostEntity> posts;

  PostLoaded({required this.posts});
  @override
  // TODO: implement props
  List<Object?> get props => [posts];
}

class PostFailure extends PostStates {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}


