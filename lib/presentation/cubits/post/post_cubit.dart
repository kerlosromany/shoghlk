// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoghlak/domin/entities/post/post_entity.dart';

import 'package:shoghlak/domin/use_cases/post/create_post_usecase.dart';
import 'package:shoghlak/domin/use_cases/post/delete_post_usecase.dart';
import 'package:shoghlak/domin/use_cases/post/like_post_usecase.dart';
import 'package:shoghlak/domin/use_cases/post/read_posts_usecase.dart';
import 'package:shoghlak/domin/use_cases/post/update_post_usecase.dart';
import 'package:shoghlak/presentation/cubits/post/post_states.dart';

class PostCubit extends Cubit<PostStates> {
  final CreatePostUseCase createPostUseCase;
  final UpdatePostUseCase updatePostUseCase;
  final DeletePostUseCase deletePostUseCase;
  final ReadPostsUseCase readPostsUseCase;
  final LikePostUseCase likePostUseCase;
  PostCubit({
    required this.createPostUseCase,
    required this.updatePostUseCase,
    required this.deletePostUseCase,
    required this.readPostsUseCase,
    required this.likePostUseCase,
  }) : super(PostInitial());

  Future<void> getPosts({required PostEntity post}) async {
    emit(PostLoading());
    try {
      final streamResponse = readPostsUseCase.call(post);
      streamResponse.listen((posts) {
        emit(PostLoaded(posts: posts));
      });
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> likePost({required PostEntity post}) async {
    emit(PostLoading());
    try {
      await likePostUseCase.call(post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> deletePost({required PostEntity post}) async {
    emit(PostLoading());
    try {
      await deletePostUseCase.call(post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> createPost({required PostEntity post}) async {
    emit(PostLoading());
    try {
      await createPostUseCase.call(post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  Future<void> updatePost({required PostEntity post}) async {
    emit(PostLoading());
    try {
      await updatePostUseCase.call(post);
    } on SocketException catch (_) {
      emit(PostFailure());
    } catch (_) {
      emit(PostFailure());
    }
  }

  
}
