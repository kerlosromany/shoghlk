// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoghlak/data/models/user/user_model.dart';
import 'package:shoghlak/domin/entities/user/user_entity.dart';

import 'package:shoghlak/domin/use_cases/user/get_single_user_usecase.dart';
import 'package:shoghlak/presentation/cubits/user/get_single_user/get_single_user_states.dart';

class GetSingleUserCubit extends Cubit<GetSingleUserStates> {
  final GetSingleUserUseCase getSingleUserUseCase;
  GetSingleUserCubit({
    required this.getSingleUserUseCase,
  }) : super(GetSingleUserInitial());

  Future<void> getSingleUser({required String uid}) async {
    emit(GetSingleUserLoading());
    try {
      final streamResponse = getSingleUserUseCase.call(uid);
      streamResponse.listen((users) {
        emit(GetSingleUserLoaded(user: users.firstWhere((element) => element.uid == uid , orElse:() => UserModel()) ));
      });
      
    } on SocketException catch (_) {
      emit(GetSingleUserFailure());
    } catch (_) {
      emit(GetSingleUserFailure());
    }
  }
}
