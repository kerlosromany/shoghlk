// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoghlak/domin/entities/comment/comment_entity.dart';

import 'package:shoghlak/domin/use_cases/comment/create_comment_usecase.dart';
import 'package:shoghlak/domin/use_cases/comment/delete_comment_usecase.dart';
import 'package:shoghlak/domin/use_cases/comment/like_comment_usecase.dart';
import 'package:shoghlak/domin/use_cases/comment/read_comments_usecase.dart';
import 'package:shoghlak/domin/use_cases/comment/update_comment_usecase.dart';
import 'package:shoghlak/presentation/cubits/comment/comment_states.dart';

class CommentCubit extends Cubit<CommentStates> {
  final CreateCommentUseCase createCommentUseCase;
  final DeleteCommentUseCase deleteCommentUseCase;
  final UpdateCommentUseCase updateCommentUseCase;
  final ReadCommentsUseCase readCommentsUseCase;
  final LikeCommentUseCase likeCommentUseCase;

  CommentCubit({
    required this.createCommentUseCase,
    required this.deleteCommentUseCase,
    required this.updateCommentUseCase,
    required this.readCommentsUseCase,
    required this.likeCommentUseCase,
  }) : super(CommentInitial());

  Future<void> getComments({required String postId}) async {
    emit(CommentLoading());
    try {
      final streamResponse = readCommentsUseCase.call(postId);
      streamResponse.listen((comments) {
        if(!isClosed){
          emit(CommentLoaded(comments: comments));
        }
        
      });
    } on SocketException catch (_) {
      emit(CommentFailure());
    } catch (_) {
      emit(CommentFailure());
    }
  }

  Future<void> likeComment({required CommentEntity comment}) async {
    emit(CommentLoading());
    try {
      await likeCommentUseCase.call(comment);
    } on SocketException catch (_) {
      emit(CommentFailure());
    } catch (_) {
      emit(CommentFailure());
    }
  }

  Future<void> deleteComment({required CommentEntity comment}) async {
    emit(CommentLoading());
    try {
      await deleteCommentUseCase.call(comment);
    } on SocketException catch (_) {
      emit(CommentFailure());
    } catch (_) {
      emit(CommentFailure());
    }
  }

  Future<void> createComment({required CommentEntity comment}) async {
    emit(CommentLoading());
    try {
      await createCommentUseCase.call(comment);
    } on SocketException catch (_) {
      emit(CommentFailure());
    } catch (_) {
      emit(CommentFailure());
    }
  }

  Future<void> updateComment({required CommentEntity comment}) async {
    emit(CommentLoading());
    try {
      await updateCommentUseCase.call(comment);
    } on SocketException catch (_) {
      emit(CommentFailure());
    } catch (_) {
      emit(CommentFailure());
    }
  }
}
