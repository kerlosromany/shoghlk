
import '../../entities/comment/comment_entity.dart';
import '../../entities/post/post_entity.dart';
import '../../repository/firebase_repository.dart';

class UpdateCommentUseCase {
  final FirebaseRepository firebaseRepository;

  UpdateCommentUseCase({required this.firebaseRepository});

  Future<void> call(CommentEntity comment) {
    return firebaseRepository.updateComment(comment);
  }
}