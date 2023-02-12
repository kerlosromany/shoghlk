import 'package:shoghlak/domin/entities/reply/reply.dart';

import '../../entities/comment/comment_entity.dart';
import '../../entities/post/post_entity.dart';
import '../../repository/firebase_repository.dart';

class DeleteReplyUseCase {
  final FirebaseRepository firebaseRepository;

  DeleteReplyUseCase({required this.firebaseRepository});

  Future<void> call(ReplyEntity reply) {
    return firebaseRepository.deleteReply(reply);
  }
}