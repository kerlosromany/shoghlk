
import '../../entities/post/post_entity.dart';
import '../../repository/firebase_repository.dart';

class UpdatePostUseCase {
  final FirebaseRepository firebaseRepository;

  UpdatePostUseCase({required this.firebaseRepository});

  Future<void> call(PostEntity post) {
    return firebaseRepository.updatePost(post);
  }
}