// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoghlak/domin/entities/user/user_entity.dart';

import 'package:shoghlak/domin/use_cases/user/sign_in_usecase.dart';
import 'package:shoghlak/domin/use_cases/user/sign_up_usecase.dart';
import 'package:shoghlak/presentation/cubits/credential/credential_states.dart';

class CredentialCubit extends Cubit<CredentialStates> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  CredentialCubit({
    required this.signInUseCase,
    required this.signUpUseCase,
  }) : super(CredentialInitial());

  Future<void> signInUser(
      {required String email, required String password}) async {
    emit(CredentialLoading());
    try {
      await signInUseCase.call(UserEntity(email: email, password: password));
      emit(CredentialSuccess());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }

  Future<void> signUpUser({required UserEntity user}) async {
    emit(CredentialLoading());
    try {
      await signUpUseCase.call(user);
      emit(CredentialSuccess());
    } on SocketException catch (_) {
      emit(CredentialFailure());
    } catch (_) {
      emit(CredentialFailure());
    }
  }
}
