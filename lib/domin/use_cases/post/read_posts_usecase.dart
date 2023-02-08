import '../../entities/post/post_entity.dart';
import '../../repository/firebase_repository.dart';

class ReadPostsUseCase {
  final FirebaseRepository firebaseRepository;

  ReadPostsUseCase({required this.firebaseRepository});

  Stream<List<PostEntity>> call(PostEntity post) {
    return firebaseRepository.readPosts(post);
  }
}
