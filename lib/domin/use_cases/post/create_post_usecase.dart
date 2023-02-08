import '../../entities/post/post_entity.dart';
import '../../repository/firebase_repository.dart';

class CreatePostUseCase {
  final FirebaseRepository firebaseRepository;

  CreatePostUseCase({required this.firebaseRepository});

  Future<void> call(PostEntity post) {
    return firebaseRepository.createPost(post);
  }
}