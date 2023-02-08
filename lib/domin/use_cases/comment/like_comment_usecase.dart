import '../../entities/comment/comment_entity.dart';
import '../../repository/firebase_repository.dart';

class LikeCommentUseCase {
  final FirebaseRepository firebaseRepository;

  LikeCommentUseCase({required this.firebaseRepository});

  Future<void> call(CommentEntity comment) {
    return firebaseRepository.likeComment(comment);
  }
}
