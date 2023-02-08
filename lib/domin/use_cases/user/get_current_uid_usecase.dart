import 'package:shoghlak/domin/repository/firebase_repository.dart';

class GetCurrentUidUseCase {
  final FirebaseRepository firebaseRepository;

  GetCurrentUidUseCase({required this.firebaseRepository});

  Future<String> call() {
    return firebaseRepository.getCurrentUid();
  }
}
