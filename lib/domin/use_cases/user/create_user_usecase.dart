import 'package:shoghlak/domin/repository/firebase_repository.dart';

import '../../entities/user/user_entity.dart';

class CreateUserUseCase {
  final FirebaseRepository firebaseRepository;

  CreateUserUseCase({required this.firebaseRepository});

  Future<void> call(UserEntity user) {
    return firebaseRepository.createUser(user);
  }
}
