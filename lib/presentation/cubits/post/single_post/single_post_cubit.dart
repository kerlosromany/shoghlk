import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoghlak/domin/use_cases/post/read_single_post_usecase.dart';
import 'package:shoghlak/presentation/cubits/post/single_post/single_post_states.dart';

class GetSinglePostCubit extends Cubit<GetSinglePostStates> {
  final ReadSinglePostUseCase readSinglePostUseCase;
  GetSinglePostCubit({required this.readSinglePostUseCase})
      : super(GetSinglePostInitial());

  Future<void> getSinglePost({required String postId}) async {
    emit(GetSinglePostLoading());
    try {
      final streamResponse = readSinglePostUseCase.call(postId);
      streamResponse.listen((posts) {
        if (!isClosed) {
          emit(GetSinglePostLoaded(post: posts.first));
        }
      });
    } on SocketException catch (_) {
      emit(GetSinglePostFailure());
    } catch (_) {
      emit(GetSinglePostFailure());
    }
  }
}
