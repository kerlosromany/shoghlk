import '../../entities/comment/comment_entity.dart';
import '../../entities/post/post_entity.dart';
import '../../repository/firebase_repository.dart';

class CreateCommentUseCase {
  final FirebaseRepository firebaseRepository;

  CreateCommentUseCase({required this.firebaseRepository});

  Future<void> call(CommentEntity comment) {
    return firebaseRepository.createComment(comment);
  }
}