import 'package:equatable/equatable.dart';
import 'package:shoghlak/domin/entities/reply/reply.dart';

abstract class ReplyStates extends Equatable {
  const ReplyStates();
}

class ReplyInitial extends ReplyStates {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ReplyLoading extends ReplyStates {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ReplyLoaded extends ReplyStates {
  final List<ReplyEntity> replys;

  const ReplyLoaded({required this.replys});
  @override
  // TODO: implement props
  List<Object?> get props => [replys];
}

class ReplyFailure extends ReplyStates {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
