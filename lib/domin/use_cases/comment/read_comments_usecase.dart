import '../../entities/comment/comment_entity.dart';
import '../../entities/post/post_entity.dart';
import '../../repository/firebase_repository.dart';

class ReadCommentsUseCase {
  final FirebaseRepository firebaseRepository;

  ReadCommentsUseCase({required this.firebaseRepository});

  Stream<List<CommentEntity>> call(String postId) {
    return firebaseRepository.readComments(postId);
  }
}
