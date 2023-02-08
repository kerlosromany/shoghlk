import 'package:shoghlak/domin/repository/firebase_repository.dart';

import '../../entities/user/user_entity.dart';

class UpdateUserUseCase {
  final FirebaseRepository firebaseRepository;

  UpdateUserUseCase({required this.firebaseRepository});

  Future<void> call(UserEntity user) {
    return firebaseRepository.updateUser(user);
  }
}
