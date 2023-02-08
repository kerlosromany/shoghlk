import 'package:shoghlak/domin/repository/firebase_repository.dart';

import '../../entities/user/user_entity.dart';

class SignUpUseCase {
  final FirebaseRepository firebaseRepository;

  SignUpUseCase({required this.firebaseRepository});

  Future<void> call(UserEntity user) {
    return firebaseRepository.signUpUser(user);
  }
}
