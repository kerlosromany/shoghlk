import 'package:shoghlak/domin/repository/firebase_repository.dart';

import '../../entities/user/user_entity.dart';

class SignInUseCase {
  final FirebaseRepository firebaseRepository;

  SignInUseCase({required this.firebaseRepository});

  Future<void> call(UserEntity user) {
    return firebaseRepository.signInUser(user);
  }
}
