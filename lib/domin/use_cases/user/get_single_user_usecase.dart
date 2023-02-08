import 'package:shoghlak/domin/repository/firebase_repository.dart';

import '../../entities/user/user_entity.dart';

class GetSingleUserUseCase {
  final FirebaseRepository firebaseRepository;

  GetSingleUserUseCase({required this.firebaseRepository});

  Stream<List<UserEntity>> call(String uid) {
    return firebaseRepository.getSingleUser(uid);
  }
}
