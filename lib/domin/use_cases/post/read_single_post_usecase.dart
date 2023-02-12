import '../../entities/post/post_entity.dart';
import '../../repository/firebase_repository.dart';

class ReadSinglePostUseCase {
  final FirebaseRepository firebaseRepository;

  ReadSinglePostUseCase({required this.firebaseRepository});

  Stream<List<PostEntity>> call(String postId) {
    return firebaseRepository.readSinglePost(postId);
  }
}
