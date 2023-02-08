import '../../entities/post/post_entity.dart';
import '../../repository/firebase_repository.dart';

class DeletePostUseCase {
  final FirebaseRepository firebaseRepository;

  DeletePostUseCase({required this.firebaseRepository});

  Future<void> call(PostEntity post) {
    return firebaseRepository.deletePost(post);
  }
}