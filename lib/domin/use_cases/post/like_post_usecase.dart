import '../../entities/post/post_entity.dart';
import '../../repository/firebase_repository.dart';

class LikePostUseCase {
  final FirebaseRepository firebaseRepository;

  LikePostUseCase({required this.firebaseRepository});

  Future<void> call(PostEntity post) {
    return firebaseRepository.likePost(post);
  }
}
