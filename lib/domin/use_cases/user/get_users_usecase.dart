import 'package:shoghlak/domin/repository/firebase_repository.dart';

import '../../entities/user/user_entity.dart';

class GetUsersUseCase {
  final FirebaseRepository firebaseRepository;

  GetUsersUseCase({required this.firebaseRepository});

  Stream<List<UserEntity>> call(UserEntity user) {
    return firebaseRepository.getUsers(user);
  }
}
