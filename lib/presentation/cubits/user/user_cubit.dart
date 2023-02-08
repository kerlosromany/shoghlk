// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoghlak/domin/entities/user/user_entity.dart';

import 'package:shoghlak/domin/use_cases/user/create_user_usecase.dart';
import 'package:shoghlak/domin/use_cases/user/get_single_user_usecase.dart';
import 'package:shoghlak/domin/use_cases/user/get_users_usecase.dart';
import 'package:shoghlak/domin/use_cases/user/update_user_usecase.dart';
import 'package:shoghlak/presentation/cubits/user/user_states.dart';

class UserCubit extends Cubit<UserStates> {
  final GetUsersUseCase getUsersUseCase;
  final UpdateUserUseCase updateUserUseCase;
  UserCubit({
    required this.getUsersUseCase,
    required this.updateUserUseCase,
  }) : super(UserInitial());

  Future<void> getUsers({required UserEntity user}) async {
    emit(UserLoading());
    try {
      final streamResponse = getUsersUseCase.call(user);
      streamResponse.listen((users) {
        emit(UserLoaded(users: users));
      });
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }

  Future<void> updateUser({required UserEntity user}) async {
    emit(UserLoading());
    try {
      await updateUserUseCase.call(user);
    } on SocketException catch (_) {
      emit(UserFailure());
    } catch (_) {
      emit(UserFailure());
    }
  }
}
