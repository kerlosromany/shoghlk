import 'package:shoghlak/domin/repository/firebase_repository.dart';


class IsSignInUseCase {
  final FirebaseRepository firebaseRepository;

  IsSignInUseCase({required this.firebaseRepository});

  Future<bool> call() {
    return firebaseRepository.isSignIn();
  }
}
