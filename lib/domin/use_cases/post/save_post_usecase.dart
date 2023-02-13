import '../../entities/post/post_entity.dart';
import '../../repository/firebase_repository.dart';

class SavePostUseCase {
  final FirebaseRepository firebaseRepository;

  SavePostUseCase({required this.firebaseRepository});

  Future<void> call(PostEntity post) {
    return firebaseRepository.savePost(post);
  }
}
