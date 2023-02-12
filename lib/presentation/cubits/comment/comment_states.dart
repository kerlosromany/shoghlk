import 'package:equatable/equatable.dart';
import 'package:shoghlak/domin/entities/comment/comment_entity.dart';

abstract class CommentStates extends Equatable {
  const CommentStates();
}

class CommentInitial extends CommentStates {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CommentLoading extends CommentStates {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CommentLoaded extends CommentStates {
  final List<CommentEntity> comments;

  CommentLoaded({required this.comments});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CommentFailure extends CommentStates {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
