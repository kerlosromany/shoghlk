
import 'package:shoghlak/domin/entities/reply/reply.dart';

import '../../entities/comment/comment_entity.dart';
import '../../entities/post/post_entity.dart';
import '../../repository/firebase_repository.dart';

class UpdateReplyUseCase {
  final FirebaseRepository firebaseRepository;

  UpdateReplyUseCase({required this.firebaseRepository});

  Future<void> call(ReplyEntity reply) {
    return firebaseRepository.updateReply(reply);
  }
}