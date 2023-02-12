// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoghlak/domin/entities/reply/reply.dart';

import 'package:shoghlak/domin/use_cases/reply/create_reply_usecase.dart';
import 'package:shoghlak/domin/use_cases/reply/delete_reply_usecase.dart';
import 'package:shoghlak/domin/use_cases/reply/read_replys_usecase.dart';
import 'package:shoghlak/domin/use_cases/reply/update_reply_usecase.dart';
import 'package:shoghlak/presentation/cubits/reply/reply_states.dart';

class ReplyCubit extends Cubit<ReplyStates> {
  final CreateReplyUseCase createReplyUseCase;
  final DeleteReplyUseCase deleteReplyUseCase;
  final ReadReplysUseCase readReplysUseCase;
  final UpdateReplyUseCase updateReplyUseCase;
  ReplyCubit({
    required this.createReplyUseCase,
    required this.deleteReplyUseCase,
    required this.readReplysUseCase,
    required this.updateReplyUseCase,
  }) : super(ReplyInitial());

  Future<void> getReplys({required ReplyEntity reply}) async {
    emit(ReplyLoading());
    try {
      final streamResponse = readReplysUseCase.call(reply);
      streamResponse.listen((replys) {
        if(!isClosed){
          emit(ReplyLoaded(replys: replys));
        }
      });
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> deleteReply({required ReplyEntity reply}) async {
    emit(ReplyLoading());
    try {
      await deleteReplyUseCase.call(reply);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> createReply({required ReplyEntity reply}) async {
    emit(ReplyLoading());
    try {
      await createReplyUseCase.call(reply);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

  Future<void> updateReply({required ReplyEntity reply}) async {
    emit(ReplyLoading());
    try {
      await updateReplyUseCase.call(reply);
    } on SocketException catch (_) {
      emit(ReplyFailure());
    } catch (_) {
      emit(ReplyFailure());
    }
  }

}
